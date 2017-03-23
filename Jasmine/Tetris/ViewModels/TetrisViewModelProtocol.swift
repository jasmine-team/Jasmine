/// Implement this class to describe how a game can be played with a Tetris Game board.
///
/// Note that the falling tile shound *not* be included in the tetris board data. This means that the
/// board data should only store tiles that are landed.
protocol TetrisViewModelProtocol: BaseViewModelProtocol, TimedProtocol {

    // MARK: Properties
    /// The delegate that the View Controller will conform to in some way, so that the Game Engine
    /// View Model can call.
    var delegate: TetrisGameViewControllerDelegate { get set }

    /// Stores the upcoming tiles that will be dropped, where index 0 will be the first to fall.
    var upcomingTiles: [String] { get }

    // MARK: Game Operations
    /// Tells the game engine to get the next tile for falling.
    ///
    /// - Returns: a tuple of the location where the tile drops from, and the label of that tile.
    func dropNextTile() -> (location: Coordinate, tileText: String)

    /// Tells the game engine to shift the falling tile to the specified position. If this is not
    /// possible, returns false.
    ///
    /// Note that there is no need to call `update(...)` or `redisplay(...)` as this falling tile
    /// is not expected to be stored in the tetris board data.
    ///
    /// - Parameter coordinate: the new position to be shifted to.
    /// - Returns: true if this shifting is allowed, false otherwise.
    func shiftFallingTile(to coordinate: Coordinate) -> Bool

    /// Ask the game engine to land the falling tile at the specified position.
    ///
    /// - Parameter coordinate: the position to land the tile.
    func landFallingTile(at coordinate: Coordinate)
}
