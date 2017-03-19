import Foundation

/// Implement this delegate for `TetriwGameEngineProtocol` to call for updating and commanding the
/// implementing game view controller.
protocol TetrisGameViewControllerDelegate: BaseGameViewControllerDelegate {

    // MARK: Database Methods
    /// Update the board data stored in the Tetris Game View Controller with a new dataset.
    ///
    /// Note that this does *not* reload all the tiles displayed on the View Controller.
    /// To do so, call a variant of `redisplayTiles`.
    ///
    /// Note also that the `boardData` property should be updated as well.
    ///
    /// - Parameter newBoardData: the mapping of all the coordinates to all the displayed values on
    ///   the tetriw tiles.
    func update(tilesWith newBoardData: [Coordinate: String])

    // MARK: Tetris Grid Display Methods
    /// Refreshes the tiles based on the tiles information stored in the View Controller's board data.
    ///
    /// Note to call `updateTiles(with board data)` if any information in the board data should be
    /// updated.
    func redisplayAllTiles()

    /// Refreshes a selected set of tiles based on the tiles information stored in the VC's board data.
    ///
    /// Note to call `updateTiles(with board data)` if any information in the board data should be
    /// updated.
    ///
    /// - Parameter coordinates: The set of coordinates to be redisplayed.
    func redisplay(tilesAt coordinates: Set<Coordinate>)

    /// Refreshes one particular tile based on the tiles information stored in the VC's board data.
    ///
    /// Note to call `updateTiles(with board data)` if any information in the board data should be
    /// updated.
    ///
    /// - Parameter coordinate: The single coordinate to be redisplayed.
    func redisplay(tileAt coordinate: Coordinate)

    // MARK: Animation
    /// Ask the view controller to animate the destruction of tiles at the specified coordinates.
    ///
    /// Note that the content of the tiles will be wiped clean after that. So update the tetris data
    /// as well.
    ///
    /// - Parameter coodinates: the set of coordinates to be destroyed.
    func animate(destroyTilesAt coodinates: Set<Coordinate>)

    // MARK: Upcoming and Falling Tile
    /// Gets the position of the falling tile. If such a position is not available, returns nil.
    var fallingTilePosition: Coordinate? { get }

    /// Tells the view controller to reload the display of the upcoming tiles.
    ///
    /// Note that this should update the relevant property as well.
    ///
    /// - Parameter tiles: the tile to be displayed as upcoming tile, where index 0 is the first 
    ///   tile that will be dropped.
    func redisplay(upcomingTiles tiles: [String])

    /// Tells the view controller to reload the display of the current tile that is falling.
    ///
    /// Note that this should update the relevant property as well.
    ///
    /// - Parameter tile: the tile to be displayed as upcoming tile.
    func redisplay(fallingTile tile: String)
}
