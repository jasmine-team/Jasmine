import Foundation

class MockGridGameEngine: GridGameEngineProtocol {

    // MARK: Properties
    /// The delegate that the View Controller will conform to in some way, so that the Game Engine
    /// View Model can call.
    weak var delegate: GridGameViewControllerDelegate?

    /// Stores the grid data that will be used to display in the view controller.
    var gridData: [Coordinate: String] = [
        Coordinate(row: 0, col: 0): "😜",
        Coordinate(row: 0, col: 1): "😉",
        Coordinate(row: 0, col: 2): "",
        Coordinate(row: 0, col: 3): "123",
        Coordinate(row: 1, col: 0): "lala",
        Coordinate(row: 1, col: 1): "😉",
        Coordinate(row: 1, col: 2): "😆",
        Coordinate(row: 1, col: 3): "😁",
        Coordinate(row: 2, col: 0): "😜",
        Coordinate(row: 2, col: 1): "😉",
        Coordinate(row: 2, col: 2): "😆",
        Coordinate(row: 2, col: 3): "😁",
        Coordinate(row: 3, col: 0): "😜",
        Coordinate(row: 3, col: 1): "😉",
        Coordinate(row: 3, col: 2): "😆",
        Coordinate(row: 3, col: 3): "😁"
    ]

    // MARK: Game Operations
    /// Tells the Game Engine View Model that the user from the View Controller attempts to swap
    /// the specified two tiles.
    ///
    /// Note that if the tiles are swapped, `delegate.updateTiles(...)` should be called to update
    /// the grid data of the cell stored in the view controller. However, there is no need to call
    /// `delegate.redisplayTiles(...)` as it will be done implicitly by the view controller when
    /// the swapping is successful (determined by the returned value).
    ///
    /// - Parameters:
    ///   - coord1: One of the cells to be swapped.
    ///   - coord2: The other cell to be swapped.
    /// - Returns: Returns true if the two coordinates has be swapped, false otherwise.
    func swapTiles(_ coord1: Coordinate, and coord2: Coordinate) -> Bool {
        swap(&gridData[coord1], &gridData[coord2])
        delegate?.update(tilesWith: gridData)
        return true
    }
}

extension MockGridGameEngine: BaseGameEngineProtocol {
    // MARK: Properties
    /// Specifies the current score of the game. If the game has not started, it will be the initial
    /// displayed score.
    var currentScore: Int {
        return 0
    }

    /// Specifies the total time allowed in the game.
    var totalTimeAllowed: TimeInterval {
        return 0
    }

    /// Specifies the remaining time left in the game.
    var remainingTimeLeft: TimeInterval {
        return 0
    }

    /// Tells the view model that the game has started.
    func startGame() {

    }
}
