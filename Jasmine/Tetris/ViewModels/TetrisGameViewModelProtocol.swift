/// Implement this class to describe how a game can be played with a Tetris Game board.
protocol TetrisGameViewModelProtocol: BaseViewModelProtocol, CountdownTimable {

    // MARK: Properties
    /// The delegate that the View Controller will conform to in some way, so that the Game Engine
    /// View Model can call.
    var delegate: TetrisGameViewControllerDelegate? { get set }

    /// Stores the upcoming tiles that will be dropped, where index 0 will be the first to fall.
    var upcomingTiles: [String] { get }

    // MARK: Game Operations
    /// Tells the game engine to get the next tile for falling.
    /// - Returns: a tuple of the location where the tile drops from, and the label of that tile.
    func dropNextTile() -> (location: Coordinate, tileText: String)

    /// Checks if it is possible to shift the falling tile to the specified coordinate.
    /// - Parameter coordinate: the coordinate to check if it can be shifted to.
    /// - Returns: true if this shifting is allowed, false otherwise.
    func canShiftFallingTile(to coordinate: Coordinate) -> Bool

    /// Asks the game engine if the falling tile can be landed at the specified coordinate.
    /// - Parameter coordinate: the coordinate to check if the falling tile can be landed at
    /// - Returns: true if the tile can be landed at `coordinate`
    func canLandTile(at coordinate: Coordinate) -> Bool

    /// Tells the game engine the tile has landed. 
    /// Game engine will add the tile to the grid and destroy tiles with matching phrases if found.
    ///
    /// - Precondition: canLandTile must be called first to update the landing coordinate
    func tileHasLanded()

    /// Swaps the falling tile with the upcoming tile at `index`
    /// - Parameter index: the index of `upcomingTiles` to be swapped
    ///
    /// - Precondition: dropNextTile must be called first to initialize the falling tile
    func swapFallingTile(withUpcomingAt index: Int)
}
