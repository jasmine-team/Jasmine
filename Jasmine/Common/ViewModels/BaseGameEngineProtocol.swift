import Foundation

/// Sets the shared functionalities that are applicable across all view model declarations.
/// This protocol will be inherited by all the specialised view model protocols.
protocol BaseGameEngineProtocol {

    // MARK: Properties
    /// Specifies the current score of the game. If the game has not started, it will be the initial
    /// displayed score.
    var currentScore: Int { get }

    /// Tells the view model that the game has started.
    func startGame()
}
