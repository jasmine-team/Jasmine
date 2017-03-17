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
}
