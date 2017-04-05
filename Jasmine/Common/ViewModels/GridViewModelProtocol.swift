import Foundation

/// Implement this class to describe how a game can be played with a Sliding Game board.
protocol GridViewModelProtocol: BaseViewModelProtocol {

    /// Highlighted coordinates in the grid.
    var highlightedCoordinates: Set<Coordinate>
}
