import Foundation

/// Denotes the status of the current game play.
///
/// - notStarted: the game has not started.
/// - inProgress: the game is currently in progress.
/// - endedWithWon: the game has ended and the user has won.
/// - endedWithLost: the game has ended and the user has lost.
/// - endedWithTimeOut: the game has ended and the user ran out of time.
enum GameStatus {
    case notStarted
    case inProgress
    case endedWithWon
    case endedWithLost
    case endedWithTimeOut
}
