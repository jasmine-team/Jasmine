import Foundation

/// Conform to this protocol (by the view model) to describe the state and the properties of this
/// game.
protocol GameDescriptorProtocol: TimeDescriptorProtocol, ScoreDescriptorProtocol {

    // MARK: - Game Properties
    /// Returns the level name for this game. 
    var levelName: String { get }

    /// Provide of a brief description of its objectives and how this game is played.
    /// There is no word count limit, but should be concise.
    var gameInstruction: String { get }

    /// Provides a list of phrases that is being tested in this game.
    var phrasesTested: Set<Phrase> { get }

    // MARK: - Game Status
    /// A delegate that notifies the implementing view controller that the game status has been
    /// updated.
    weak var gameStatusDelegate: GameStatusUpdateDelegate? { get set }

    /// The status of the current game.
    var gameStatus: GameStatus { get }
}
