/// Implement this class to describe how a game can be played with a Tetris Game board.
protocol TetrisGameViewModelProtocol: BaseViewModelProtocol {

    // MARK: Properties
    /// The delegate that the View Controller will conform to in some way, so that the Game Engine
    /// View Model can call.
    var delegate: TetrisGameViewControllerDelegate? { get set }

    /// Stores the upcoming tiles that will be dropped, where index 0 will be the first to fall.
    var upcomingTiles: [String] { get }

    // MARK: Game Operations
    /// Tells the game engine to get the next tile for falling.
    ///
    /// - Returns: a tuple of the location where the tile drops from, and the label of that tile.
    func dropNextTile() -> (location: Coordinate, tileText: String)

    /// Checks if it is possible to shift the falling tile to the specified coordinate.
    ///
    /// - Parameter coordinate: the coordinate to check if it can be shifted to.
    /// - Returns: true if this shifting is allowed, false otherwise.
    func canShiftFallingTile(to coordinate: Coordinate) -> Bool

    /// Ask the game engine to land the falling tile at the specified position.
    ///
    /// - Parameter coordinate: the position to land the tile.
    func landFallingTile(at coordinate: Coordinate)

    /// Swaps the current tile with the upcoming tile at `index`
    ///
    /// - Parameter index: the index of `upcomingTiles` to be swapped
    func swapFallingTile(withUpcomingAt index: Int)
}
