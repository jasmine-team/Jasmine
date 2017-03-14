import Foundation

/// Protocol that defines the Grid ViewModel.
protocol GridViewModelProtocol {
    /// The grid of the game.
    var grid: [IndexPath: Character] { get }

    /// The grid ViewController delegate
    var delegate: GridViewControllerDelegate { get }

    /// The time remaining, in seconds, to complete the game.
    var time: TimeInterval { get }

    /// Creates a game.
    ///
    /// - Parameters:
    ///   - type: type of the game
    ///   - time: initial time limit
    ///   - delegate: the grid ViewController delegate
    init(type: GameType, time: TimeInterval, delegate: GridViewControllerDelegate)

    /// Swaps two tiles in the grid.
    func swapTile(at first: IndexPath, with second: IndexPath)
}
