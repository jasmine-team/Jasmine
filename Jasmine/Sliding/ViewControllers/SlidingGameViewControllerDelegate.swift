import Foundation

/// Implement this delegate for `SlidingViewModelProtocol` to call for updating and commanding the
/// implementing game view controller.
protocol SlidingGameViewControllerDelegate: BaseGameViewControllerDelegate {

    /// Update the grid data stored in the Grid Game View Controller with a new dataset.
    func updateGridData()

    /// Refreshes the tiles based on the tiles information stored in the View Controller's grid data.
    ///
    /// Note to call `updateGridData` if any information in the grid data should be
    /// updated.
    func redisplayAllTiles()
}
