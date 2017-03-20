import Foundation

/// Sets the shared functionalities that are applicable across all view model declarations.
/// This protocol will be inherited by all the specialised view model protocols.
protocol BaseViewModelProtocol {

    // MARK: Game Properties
    /// Specifies the current score of the game. If the game has not started, it will be the initial
    /// displayed score.
    var currentScore: Int { get }

    /// Provide a brief title for this game. Note that this title should be able to fit within the
    /// width of the display.
    var gameTitle: String { get }

    /// Provide of a brief description of its objectives and how this game is played. 
    /// There is no word count limit, but should be concise.
    var gameInstruction: String { get }

    // MARK: Game Actions
    /// Tells the view model that the game has started.
    func startGame()
}
