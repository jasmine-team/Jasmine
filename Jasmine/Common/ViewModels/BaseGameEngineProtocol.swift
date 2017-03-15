import Foundation

/// Sets the shared functionalities that are applicable across all game engine declarations.
/// This protocol will be inherited by all the specialsied game engine view model protocols.
protocol BaseGameEngineProtocol {

    /// Tells the view model that the game has started.
    func startGame()
}
