import Foundation

class BaseSlidingViewModel: GridViewModel, SlidingViewModelProtocol {
    /// The delegate that the View Controller will conform to in some way, so that the Game Engine
    /// View Model can call.
    weak var delegate: SlidingGameViewControllerDelegate?

    /// Initializes the grid VM.
    ///
    /// - Parameters:
    ///   - time: total time allowed
    ///   - tiles: tiles in the game
    ///   - possibleAnswers: all possible answers. The game is won if all rows in the game is in all possible answers.
    ///   - rows: number of rows in the grid.
    ///   - columns: number of columns in the grid.
    init(time: TimeInterval, gameData: GameData, tiles: [String?], rows: Int, columns: Int) {
        assert(rows > 0 && columns > 0, "Number of rows and columns should be more than 0")
        assert(tiles.count == rows * columns, "Number of tiles should equal numRows * numColumns")

        let shuffledTiles = tiles.shuffled()
        let grid = (0..<rows).map { row in
            (0..<columns).map { col in
                shuffledTiles[row * columns + col]
            }
        }

        super.init(time: time, gameData: gameData, textGrid: TextGrid(fromInitialGrid: grid))

        timer.timerListener = gridTimerListener
    }

    /// Tells the Game Engine View Model that the user from the View Controller attempts to slide
    /// the tile.
    ///
    /// Note that if the tiles are slided, `delegate.updateGridData()` should be called to update
    /// the grid data of the cell stored in the view controller. However, there is no need to call
    /// `delegate.redisplayAllTiles` as it will be done implicitly by the view controller when
    /// the sliding is successful (determined by the returned value).
    ///
    /// - Parameters:
    ///   - start: The tile to be slided.
    ///   - end: The destination of the sliding tile. Should be empty.
    /// - Returns: Returns true if the tile successfully slided, false otherwise.
    @discardableResult
    func slideTile(from start: Coordinate, to end: Coordinate) -> Bool {
        guard canTileSlide(from: start).contains(where: { $0.value == end }),
              gridData[start] != nil, gridData[end] == nil else {
            return false
        }

        gridData.swap(start, end)
        delegate?.updateGridData()
        checkGameWon()

        return true
    }

    /// Score for the game when it is won on the current state.
    override var score: Int {
        return Int(timeRemaining * Double(Constants.Game.Sliding.scoreMultiplierFromTime))
    }

    /// Ask the view model where the specified tile from the coordinate can be slided to.
    ///
    /// - Parameters:
    ///   - start: the starting coordinate where the tile slides from.
    /// - Returns: returns a dictionary of direction and the last coordinate that the tile can slide
    ///   towards. However, if that is not a valid direction, do not add as an entry to the dictionary.
    /// - Note: if the tile from the `start` should never be slided in the first place, returns empty
    ///   dictionary
    func canTileSlide(from start: Coordinate) -> [Direction: Coordinate] {
        guard gridData.isInBounds(coordinate: start) else {
            return [:]
        }

        var result: [Direction: Coordinate] = [:]

        let top = Coordinate(row: start.row - 1, col: start.col)
        let bottom = Coordinate(row: start.row + 1, col: start.col)
        let left = Coordinate(row: start.row, col: start.col - 1)
        let right = Coordinate(row: start.row, col: start.col + 1)

        if gridData.isInBounds(coordinate: top) {
            result[.northwards] = top
        }
        if gridData.isInBounds(coordinate: bottom) {
            result[.southwards] = bottom
        }
        if gridData.isInBounds(coordinate: left) {
            result[.westwards] = left
        }
        if gridData.isInBounds(coordinate: right) {
            result[.eastwards] = right
        }

        return result
    }

    /// The countdown timer for use in this ViewModel.
    ///
    /// - Returns: the countdown timer
    private func gridTimerListener(status: TimerStatus) {
        switch status {
        case .start:
            gameStatus = .inProgress
            delegate?.redisplay(timeRemaining: timeRemaining, outOf: totalTimeAllowed)
        case .tick:
            delegate?.redisplay(timeRemaining: timeRemaining, outOf: totalTimeAllowed)
        case .finish:
            gameStatus = .endedWithLost
        default:
            break
        }
    }
}
