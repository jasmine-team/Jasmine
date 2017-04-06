import Foundation

/// Denotes the status of the current game play.
///
/// - notStarted: the game has not started.
/// - inProgress: the game is currently in progress.
/// - endedWithWon: the game has ended and the user has won.
/// - endedWithLost: the game has ended and the user has lost.
enum GameStatus {
    case notStarted
    case inProgress
    case endedWithWon
    case endedWithLost

    /// Returns true if the game has ended.
    var hasGameEnded: Bool {
        return self == .endedWithWon || self == .endedWithLost
    }
}
