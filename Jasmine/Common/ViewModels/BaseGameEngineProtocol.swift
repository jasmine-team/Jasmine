import Foundation

/// Sets the shared functionalities that are applicable across all game engine declarations.
/// This protocol will be inherited by all the specialsied game engine view model protocols.
protocol BaseGameEngineProtocol {

    /* Properties */
    /// Specifies the current score of the game. If the game has not started, it will be the initial
    /// displayed score.
    var currentScore: Int { get }

    /// Specifies the total time allowed in the game.
    var totalTimeAllowed: TimeInterval { get }

    /// Specifies the remaining time left in the game.
    var remainingTimeLeft: TimeInterval { get }

    /// Tells the view model that the game has started.
    func startGame()
}
