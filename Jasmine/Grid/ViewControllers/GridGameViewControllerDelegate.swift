import Foundation

/// Implement this delegate for `GridViewModelProtocol` to call for updating and commanding the
/// implementing game view controller.
protocol GridGameViewControllerDelegate: BaseGameViewControllerDelegate {

    /// Update the grid data stored in the Grid Game View Controller with a new dataset.
    ///
    /// Note that this does *not* reload all the tiles displayed on the View Controller.
    /// To do so, call redisplayAllTiles.
    func updateGridData()
}
