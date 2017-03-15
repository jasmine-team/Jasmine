import Foundation

/// Implement this class to describe how a game can be played with a Tetris Game board.
///
/// Note that the falling tile shound *not* be included in the tetris board data. This means that the
/// board data should only store tiles that are landed.
protocol TetrisGameEngineProtocol: BaseGameEngineProtocol {

    /* Properties */
    /// The delegate that the View Controller will conform to in some way, so that the Game Engine
    /// View Model can call.
    var delegate: TetrisGameViewControllerDelegate { get set }

    /// Stores the tetris data that will be used to display in the view controller.
    ///
    /// Note also that the falling tile should not be stored inside the tetris board data. Only tiles
    /// that are stationary should be displayed.
    var boardData: [Coordinate: String] { get }

    /// Stores the upcoming tile that will be dropped.
    var upcomingTile: String { get }

    /// Stores the currently falling tile. Nil if there is no tile that is falling.
    var currentTile: String? { get }

    /* Methods */
    /// Tells the game engine to get the next tile for falling.
    func dropNextTile() -> String

    /// Asks the Game Engine if the falling tile can be shifted to the specified position, if so
    /// returns true and perform this shifting. False otherwise.
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
    /// - Returns: true if this move is successful.
    func landFallingTile(at coordinate: Coordinate) -> Bool
}
