import Foundation

/// Implement this class to describe how a game can be played with a Sliding Game board.
protocol SlidingViewModelProtocol: BaseViewModelProtocol, CountdownTimable {

    // MARK: Properties
    /// The delegate that the View Controller will conform to in some way, so that the Game Engine
    /// View Model can call.
    var delegate: GridGameViewControllerDelegate? { get set }

    /// Stores the grid data that will be used to display in the view controller.
    var gridData: [Coordinate: String] { get }

    // MARK: Game Operations
    /// Tells the Game Engine View Model that the user from the View Controller attempts to slide
    /// the tile.
    ///
    /// Note that if the tiles are slided, `delegate.updateGridData()` should be called to update
    /// the grid data of the cell stored in the view controller. However, there is no need to call
    /// `delegate.redisplayAllTiles` as it will be done implicitly by the view controller when
    /// the sliding is successful (determined by the returned value).
    ///
    /// - Parameters:
    ///   - start: The tile to be slided.
    ///   - end: The destination of the sliding tile. Should be empty.
    /// - Returns: Returns true if the tile successfully slided, false otherwise.
    func slideTile(from start: Coordinate, to end: Coordinate) -> Bool
}
