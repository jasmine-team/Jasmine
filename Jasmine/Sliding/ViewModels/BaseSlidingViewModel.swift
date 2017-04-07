import Foundation

class BaseSlidingViewModel: GridViewModel, SlidingViewModelProtocol {
    typealias Score = GameConstants.Sliding.Score

    /// The number of moves currently done.
    var moves: Int = 0

    /// The status of the current game.
    override var gameStatus: GameStatus {
        didSet {
            gameStatusDelegate?.gameStatusDidUpdate()

            if gameStatus == .endedWithWon {
                timer.stopTimer()
            }
        }
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
        guard canTileSlide(from: start).contains(where: { $0.value == end }) else {
            return false
        }

        gridData.swap(start, end)
        moves += 1

        return true
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
        guard gridData.isInBounds(coordinate: start), gridData[start] != nil else {
            return [:]
        }

        var result: [Direction: Coordinate] = [
            .northwards: Coordinate(row: start.row - 1, col: start.col),
            .southwards: Coordinate(row: start.row + 1, col: start.col),
            .westwards: Coordinate(row: start.row, col: start.col - 1),
            .eastwards: Coordinate(row: start.row, col: start.col + 1)
        ]

        for (dir, coord) in result {
            if !gridData.isInBounds(coordinate: coord) || gridData[coord] != nil {
                result[dir] = nil
            }
        }
        return result
    }

    /// Check what happens when game is won. If game is won, change game status and add score.
    func checkCorrectTiles() {
        var highlightedCoordinates: Set<Coordinate> = []
        var score = 0

        for row in 0..<gridData.numRows {
            let rowTiles = (0..<gridData.numColumns).map { column in Coordinate(row: row, col: column) }
            if lineIsCorrect(rowTiles) {
                highlightedCoordinates.formUnion(rowTiles)
                score += Score.line
            }
        }
        for column in 0..<gridData.numColumns {
            let columnTiles = (0..<gridData.numRows).map { row in Coordinate(row: row, col: column) }
            if lineIsCorrect(columnTiles) {
                highlightedCoordinates.formUnion(columnTiles)
                score += Score.line
            }
        }

        if self.highlightedCoordinates != highlightedCoordinates {
            self.highlightedCoordinates = highlightedCoordinates
        }

        // In the sliding game, it is enough to have (rows - 1) rows correct
        if highlightedCoordinates.count == gridData.count - GameConstants.Sliding.columns {
            score += max(Score.win + Int(timeRemaining * Score.multiplierFromTime) -
                moves * Score.multiplierFromMoves, 0)
            gameStatus = .endedWithWon
        }

        currentScore = score
    }
}
