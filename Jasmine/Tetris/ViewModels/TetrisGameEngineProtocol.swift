import Foundation

/// Implement this class to describe how a game can be played with a Tetris Game board.
protocol TetrisGameEngineProtocol: BaseGameEngineProtocol {

    /* Properties */
    /// The delegate that the View Controller will conform to in some way, so that the Game Engine
    /// View Model can call.
    var delegate: TetrisGameViewControllerDelegate { get set }

    /* Methods */
    /// Tells the geme engine view model that the currently falling tile is shifting to the left.
    /// The view model will update the view by calling `update(withTiles ...)` and `redisplay(...)`.
    func shiftFallingTileLeft()

    /// Tells the geme engine view model that the currently falling tile is shifting to the right.
    /// The view model will update the view by calling `update(withTiles ...)` and `redisplay(...)`.
    func shiftFallingTileRight()
}
