import Foundation

/// Sets the shared functionalities that are applicable across all game view controller delegates.
/// This protocol will be inherited by all the specialsied game view controller delegates.
protocol BaseGameViewControllerDelegate {

    /// Redisplay the score displayed on the view controller screen with a new score.
    ///
    /// - Parameter newScore: the new score to be redisplayed.
    func redisplay(_ newScore: Int)

    /// Redisplay the time remaining on the view controller against a total time.
    ///
    /// - Parameters:
    ///   - timeRemaining: the remaining time left, in seconds.
    ///   - totalTime: the total time from the start of the game, in seconds.
    func redisplay(_ timeRemaining: TimeInterval, outOf totalTime: TimeInterval)
}
