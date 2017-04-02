import Foundation

/// Implement this delegate for `GridViewModelProtocol` to call for updating and commanding the
/// implementing game view controller.
protocol GridGameViewControllerDelegate: BaseGameViewControllerDelegate {

    /// Update the grid data stored in the Grid Game View Controller with a new dataset.
    ///
    /// Note that this does *not* reload all the tiles displayed on the View Controller.
    /// To do so, call redisplayAllTiles.
    func updateGridData()

    /// Refreshes the tiles based on the tiles information stored in the View Controller's grid data.
    ///
    /// Note to call `update(tilesWith newGridData)` if any information in the grid data should be
    /// updated.
    func redisplayAllTiles()

    /// Refreshes a selected set of tiles based on the tiles information stored in the VC's grid data.
    ///
    /// Note to call `update(tilesWith newGridData)` if any information in the grid data should be
    /// updated.
    ///
    /// - Parameter coordinates: The set of coordinates to be redisplayed.
    func redisplay(tilesAt coordinates: Set<Coordinate>)

    /// Refreshes one particular tile based on the tiles information stored in the VC's grid data.
    ///
    /// Note to call `update(tilesWith newGridData)` if any information in the grid data should be
    /// updated.
    ///
    /// - Parameter coordinate: The single coordinate to be redisplayed.
    func redisplay(tileAt coordinate: Coordinate)
}
