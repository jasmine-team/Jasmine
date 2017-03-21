import Foundation

/// Sets the shared functionalities that are applicable across all view model declarations.
/// This protocol will be inherited by all the specialised view model protocols.
protocol BaseViewModelProtocol {

    // MARK: Properties
    /// Specifies the current score of the game. If the game has not started, it will be the initial
    /// displayed score.
    var currentScore: Int { get }

    /// The status of the current game.
    var gameStatus: GameStatus { get set }

    /// Tells the view model that the game has started.
    func startGame()
}
