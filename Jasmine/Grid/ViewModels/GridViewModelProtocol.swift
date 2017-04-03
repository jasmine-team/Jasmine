import Foundation

/// Implement this class to describe how a game can be played with a Grid Game board.
protocol GridViewModelProtocol: BaseViewModelProtocol {

    // MARK: Game Operations
    /// Tells the Game Engine View Model that the user from the View Controller attempts to swap
    /// the specified two tiles.
    ///
    /// - Parameters:
    ///   - coord1: One of the cells to be swapped.
    ///   - coord2: The other cell to be swapped.
    /// - Returns: Returns true if the two coordinates has swapped, false otherwise.
    func swapTiles(_ coord1: Coordinate, and coord2: Coordinate) -> Bool
}
