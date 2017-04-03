/// Implement this class to describe how a game can be played with a Tetris Game board.
protocol TetrisGameViewModelProtocol: BaseViewModelProtocol, CountdownTimable {

    // MARK: Properties
    /// The delegate that the View Controller will conform to in some way, so that the Game Engine
    /// View Model can call.
    var delegate: BaseGameViewControllerDelegate? { get set }

    /// Stores the upcoming tiles that will be dropped, where index 0 will be the first to fall.
    var upcomingTiles: [String] { get }

    /// Stores the falling tile text
    var fallingTileText: String! { get }

    // MARK: Game Operations
    /// Asks the game engine the coordinate for a new tile
    /// - Returns: the coordinate to drop the new tile from
    func getNewTileCoordinate() -> Coordinate

    /// Checks if it is possible to shift the falling tile to the specified coordinate.
    /// - Parameter coordinate: the coordinate to check if it can be shifted to.
    /// - Returns: true if this shifting is allowed, false otherwise.
    func canShiftFallingTile(to coordinate: Coordinate) -> Bool

    /// Asks the game engine to land at the specified coordinate.
    /// - Parameter coordinate: the coordinate to land the tile at
    /// - Returns: true if the tile successfully landed at `coordinate`
    func tryLandTile(at coordinate: Coordinate) -> Bool

    func getDestroyedAndShiftedTiles(at coordinate: Coordinate) ->
            [(destroyedTiles: Set<Coordinate>, shiftedTiles: [(from: Coordinate, to: Coordinate)])]

    func landTile(from coordinate: Coordinate) -> Coordinate

    /// Swaps the falling tile with the upcoming tile at `index`
    /// - Parameter index: the index of `upcomingTiles` to be swapped
    ///
    /// - Precondition: dropNextTile must be called first to initialize the falling tile
    func swapFallingTile(withUpcomingAt index: Int)
}
