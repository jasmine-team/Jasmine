import Foundation

/// Implement this class to describe how a game can be played with a Sliding Game board.
protocol SlidingViewModelProtocol: BaseViewModelProtocol {

    // MARK: Game Operations
    /// Ask the view model where the specified tile from the coordinate can be slided to.
    ///
    /// - Parameters:
    ///   - start: the starting coordinate where the tile slides from.
    /// - Returns: returns a dictionary of direction and the last coordinate that the tile can slide
    ///   towards. However, if that is not a valid direction, do not add as an entry to the dictionary.
    /// - Note: if the tile from the `start` should never be slided in the first place, returns empty
    ///   dictionary
    func canTileSlide(from start: Coordinate) -> [Direction: Coordinate]

    /// Tells the Game Engine View Model that the user from the View Controller attempts to slide
    /// the tile.
    ///
    /// - Parameters:
    ///   - start: The tile to be slided.
    ///   - end: The destination of the sliding tile. Should be empty.
    /// - Returns: Returns true if the tile successfully slided, false otherwise.
    func slideTile(from start: Coordinate, to end: Coordinate) -> Bool
}
