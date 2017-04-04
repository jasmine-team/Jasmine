import Foundation

protocol ScoreDescriptorProtocol {
    
    // MARK: - Game Scoring
    /// A delegate that notifies the implementing view controller that the score has been updated.
    weak var scoreDelegate: ScoreUpdateDelegate? { get set }

    /// Specifies the current score of the game. If the game has not started, it will be the initial
    /// displayed score.
    var currentScore: Int { get }
}
