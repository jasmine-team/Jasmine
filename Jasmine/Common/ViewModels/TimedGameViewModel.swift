import Foundation

/// View model with a countdown timer
class TimedGameViewModel: GameViewModel {

    /// Specifies the time remaining in the game.
    private(set) var timeRemaining: TimeInterval

    /// Specifies the total time allowed in the game.
    private(set) var totalTimeAllowed: TimeInterval

    /// Retrieves time elapsed since game started
    var timeElapsed: TimeInterval {
        return totalTimeAllowed - timeRemaining
    }

    /// Initialize the total time allowed and sets timeRemaining to it
    init(totalTimeAllowed: TimeInterval) {
        assert(totalTimeAllowed >= 0, "totalTimeAllowed must be positive")
        self.totalTimeAllowed = totalTimeAllowed
        timeRemaining = totalTimeAllowed
    }

    /// Starts the countdown timer
    func startTimer(timerInterval: TimeInterval, viewControllerDelegate: BaseGameViewControllerDelegate?) {
        assert(timerInterval >= 0, "timerInterval must be positive")
        viewControllerDelegate?.notifyGameStatus(with: .inProgress)

        Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
            self.timeRemaining -= timerInterval
            viewControllerDelegate?.redisplay(timeRemaining: self.timeRemaining, outOf: self.totalTimeAllowed)

            if self.timeRemaining == 0 {
                viewControllerDelegate?.notifyGameStatus(with: .endedWithLost)
                timer.invalidate()
            }
        }
    }
}
