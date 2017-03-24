import Foundation

/// Implement this delegate for `GridViewModelProtocol` to call for updating and commanding the
/// implementing game view controller.
protocol GridGameViewControllerDelegate: BaseGameViewControllerDelegate {

    /// Update the grid data stored in the Grid Game View Controller with a new dataset.
    ///
    /// Note that this does *not* reload all the tiles displayed on the View Controller.
    /// To do so, call a variant of `redisplayTiles`.
    func updateGridData()

    /// Refreshes the tiles based on the tiles information stored in the View Controller's grid data.
    ///
    /// Note to call `update(tilesWith newGridData)` if any information in the grid data should be
    /// updated.
    func redisplayAllTiles()
}
