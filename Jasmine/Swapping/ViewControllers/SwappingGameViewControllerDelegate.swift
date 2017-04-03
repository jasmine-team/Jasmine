import Foundation

/// Implement this delegate for `SwappingViewModelProtocol` to call for updating and commanding the
/// implementing game view controller.
protocol SwappingGameViewControllerDelegate: BaseGameViewControllerDelegate {

    /// Update the grid data stored in the Swapping Game View Controller with a new dataset.
    ///
    /// Note that this does *not* reload all the tiles displayed on the View Controller.
    /// To do so, call redisplayAllTiles.
    func updateGridData()
}
