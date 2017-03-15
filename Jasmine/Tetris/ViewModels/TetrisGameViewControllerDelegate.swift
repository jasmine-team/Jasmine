import Foundation

/// Implement this delegate for `TetriwGameEngineProtocol` to call for updating and commanding the
/// implementing game view controller.
protocol TetrisGameViewControllerDelegate: BaseGameViewControllerDelegate {

    /// Update the database stored in the Tetris Game View Controller with a new dataset.
    ///
    /// Note that this does *not* reload all the tiles displayed on the View Controller.
    /// To do so, call a variant of `redisplayTiles`.
    ///
    /// - Parameter newTetrisData: the mapping of all the coordinates to all the displayed values on
    ///   the tetriw tiles.
    func update(tilesWith newTetrisData: [Coordinate: String])

    /// Refreshes the tiles based on the tiles information stored in the View Controller's database.
    ///
    /// Note to call `updateTiles(with database)` if any information in the database should be
    /// updated.
    func redisplayAllTiles()

    /// Refreshes a selected set of tiles based on the tiles information stored in the VC's database.
    ///
    /// Note to call `updateTiles(with database)` if any information in the database should be
    /// updated.
    ///
    /// - Parameter coordinates: The set of coordinates to be redisplayed.
    func redisplay(tilesAt coordinates: Set<Coordinate>)

    /// Refreshes one particular tile based on the tiles information stored in the VC's database.
    ///
    /// Note to call `updateTiles(with database)` if any information in the database should be
    /// updated.
    ///
    /// - Parameter coordinate: The single coordinate to be redisplayed.
    func redisplay(tileAt coordinate: Coordinate)
}
