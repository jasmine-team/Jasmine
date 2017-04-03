import Foundation

/// Conform to this protocol (by the view model) to describe the state and the properties of this
/// game.
protocol GameDescriptionProtocol {

    // MARK: - Game Properties
    /// Provide a brief title for this game. Note that this title should be able to fit within the
    /// width of the display.
    var gameTitle: String { get }

    /// Provide of a brief description of its objectives and how this game is played.
    /// There is no word count limit, but should be concise.
    var gameInstruction: String { get }

    // MARK: - Game Status
    /// A delegate that notifies the implementing view controller that the game status has been
    /// updated.
    weak var gameStatusDelegate: GameStatusUpdateDelegate? { get }

    /// The status of the current game.
    var gameStatus: GameStatus { get }

    // MARK: - Game Scoring
    /// A delegate that notifies the implementing view controller that the score has been updated.
    weak var scoreDelegate: ScoreUpdateDelegate? { get }

    /// Specifies the current score of the game. If the game has not started, it will be the initial
    /// displayed score.
    var currentScore: Int { get }
}
