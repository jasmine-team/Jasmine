import Foundation

/// Implement this class to describe how a game can be played with a Sliding Game board.
protocol SlidingViewModelProtocol: BaseViewModelProtocol {

    // MARK: Game Operations
    /// Tells the Game Engine View Model that the user from the View Controller attempts to slide
    /// the tile.
    ///
    /// - Parameters:
    ///   - start: The tile to be slided.
    ///   - end: The destination of the sliding tile. Should be empty.
    /// - Returns: Returns true if the tile successfully slided, false otherwise.
    func slideTile(from start: Coordinate, to end: Coordinate) -> Bool
}
