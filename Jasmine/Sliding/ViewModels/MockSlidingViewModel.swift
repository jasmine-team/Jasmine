import Foundation

class MockSlidingViewModel: SlidingViewModelProtocol, CountdownTimable {

    var timer: CountDownTimer = CountDownTimer(totalTimeAllowed: 10_000)

    // MARK: Properties
    /// The delegate that the View Controller will conform to in some way, so that the Game Engine
    /// View Model can call.
    weak var delegate: SlidingGameViewControllerDelegate?

    /// Stores the grid data that will be used to display in the view controller.
    var gridData: [Coordinate: String] = [
        Coordinate(row: 0, col: 0): "A",
        Coordinate(row: 0, col: 1): "B",
        Coordinate(row: 0, col: 2): "C",
        Coordinate(row: 0, col: 3): "D",
        Coordinate(row: 1, col: 0): "E",
        Coordinate(row: 1, col: 1): "F",
        Coordinate(row: 1, col: 2): "G",
        Coordinate(row: 1, col: 3): "H",
        Coordinate(row: 2, col: 0): "I",
        Coordinate(row: 2, col: 1): "J",
        Coordinate(row: 2, col: 2): "K",
        Coordinate(row: 2, col: 3): "K",
    ]

    // MARK: Game Operations
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
    func slideTile(from start: Coordinate, to end: Coordinate) -> Bool {
        guard !gridData.keys.contains(end) else {
            return false
        }
        gridData[end] = gridData.removeValue(forKey: start)
        delegate!.updateGridData()
        return true
    }

    func canTileSlide(from coordinate: Coordinate) -> [Direction: Coordinate] {
        var allowedDirections: [Direction: Coordinate] = [:]

        if !gridData.keys.contains(coordinate.nextCol) {
            allowedDirections[.eastwards] = coordinate.nextCol
        }
        if !gridData.keys.contains(coordinate.prevCol) {
            allowedDirections[.westwards] = coordinate.prevCol
        }
        if !gridData.keys.contains(coordinate.nextRow) {
            allowedDirections[.southwards] = coordinate.nextRow
        }
        if !gridData.keys.contains(coordinate.prevRow) {
            allowedDirections[.northwards] = coordinate.prevRow
        }
        return allowedDirections
    }
}

extension MockSlidingViewModel: BaseViewModelProtocol {
    /// Specifies the current score of the game. If the game has not started, it will be the initial
    /// displayed score.
    var currentScore: Int {
        return 100
    }

    /// Provide a brief title for this game. Note that this title should be able to fit within the
    /// width of the display.
    var gameTitle: String {
        return "no title"
    }

    /// Provide of a brief description of its objectives and how this game is played.
    /// There is no word count limit, but should be concise.
    var gameInstruction: String {
        return "some instructions"
    }

    // MARK: Game Actions
    /// The status of the current game.
    var gameStatus: GameStatus {
        return .inProgress
    }

    /// Tells the view model that the game has started.
    func startGame() {

    }
}
