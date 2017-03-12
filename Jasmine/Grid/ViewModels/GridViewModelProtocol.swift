import Foundation

/// Protocol that defines the Grid ViewModel.
protocol GridViewModelProtocol {
    /// The grid of the game.
    var grid: [IndexPath: Character] { get }

    /// The time remaining, in seconds, to complete the game.
    var time: Int { get }

    /// Creates a game.
    ///
    /// - Parameters:
    ///   - type: type of the game
    ///   - time: initial time limit
    init(type: GameType, time: Int)

    /// Swaps two tiles in the grid.
    func swapTile(at first: IndexPath, with second: IndexPath)
}
