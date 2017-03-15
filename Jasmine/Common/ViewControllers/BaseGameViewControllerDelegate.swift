import Foundation

/// Sets the shared functionalities that are applicable across all game view controller delegates.
/// This protocol will be inherited by all the specialsied game view controller delegates.
protocol BaseGameViewControllerDelegate {

    /* Score Update */
    /// A constant that indicates the initial score that is started with the game.
    var initialScore: Int { get }

    /// Redisplay the score displayed on the view controller screen with a new score.
    ///
    /// - Parameter newScore: the new score to be redisplayed.
    func redisplay(_ newScore: Int)

    /* Time Update */
    /// A constant that indicates the initial time remaining that is started with the game.
    var initialRemainingTime: TimeInterval { get }

    /// Redisplay the time remaining on the view controller against a total time.
    ///
    /// - Parameters:
    ///   - timeRemaining: the remaining time left, in seconds.
    ///   - totalTime: the total time from the start of the game, in seconds.
    ///     If no bonus time is added, should equate to `initialRemainingTime`.
    func redisplay(_ timeRemaining: TimeInterval, outOf totalTime: TimeInterval)

    /* Game Status */
    /// Notifies the view controller that the game state has changed.
    /// 
    /// This is also the place to indicate when the user has won/lost.
    /// Note also that if the user has won/lost, the score in the `redisplay(_ newScore)` will be
    /// taken as the end game score. So update it before calling end game.
    ///
    /// - Parameter newStatus: the new status of the current game session.
    func notifyGameStatus(with newStatus: GameStatus)
}
