import Foundation

/// View model with a countdown timer
class TimedGameViewModel: GameViewModel {

    /// Specifies the remaining time left in the game.
    private(set) var timeRemaining: TimeInterval = 0.0

    /// Specifies the total time allowed in the game.
    private(set) var totalTimeAllowed: TimeInterval

    /// Retrieves time elapsed since game started
    var timeElapsed: TimeInterval {
        return totalTimeAllowed - timeRemaining
    }

    /// Initialize the total time allowed
    init(totalTimeAllowed: TimeInterval) {
        self.totalTimeAllowed = totalTimeAllowed
    }

    /// Starts the countdown timer
    func startTimer(timerInterval: TimeInterval, viewControllerDelegate: BaseGameViewControllerDelegate?) {
        Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
            self.timeRemaining -= 1
            viewControllerDelegate?.redisplay(timeRemaining: self.timeRemaining, outOf: self.totalTimeAllowed)

            if self.timeRemaining == 0 {
                viewControllerDelegate?.notifyGameStatus(with: .endedWithLost)
                timer.invalidate()
            }
        }
    }
}
