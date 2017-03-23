import Foundation

/// Implement this class to describe how a game can be played with a Grid Game board.
protocol GridViewModelProtocol: BaseViewModelProtocol, TimedProtocol {

    // MARK: Properties
    /// The delegate that the View Controller will conform to in some way, so that the Game Engine
    /// View Model can call.
    var delegate: GridGameViewControllerDelegate? { get set }

    /// Stores the grid data that will be used to display in the view controller.
    var gridData: [Coordinate: String] { get }

    // MARK: Game Operations
    /// Tells the Game Engine View Model that the user from the View Controller attempts to swap
    /// the specified two tiles.
    ///
    /// Note that if the tiles are swapped, `delegate.updateTiles(...)` should be called to update
    /// the grid data of the cell stored in the view controller. However, there is no need to call
    /// `delegate.redisplayTiles(...)` as it will be done implicitly by the view controller when
    /// the swapping is successful (determined by the returned value).
    ///
    /// - Parameters:
    ///   - coord1: One of the cells to be swapped.
    ///   - coord2: The other cell to be swapped.
    /// - Returns: Returns true if the two coordinates has be swapped, false otherwise.
    func swapTiles(_ coord1: Coordinate, and coord2: Coordinate) -> Bool
}
