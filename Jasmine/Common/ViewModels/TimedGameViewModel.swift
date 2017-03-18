import Foundation

/// View model with a countdown timer
protocol TimedGameViewModel: class {

    /// Specifies the time remaining in the game.
    var timeRemaining: TimeInterval { get set }

    /// Specifies the total time allowed in the game.
    var totalTimeAllowed: TimeInterval { get set }

    /// Retrieves time elapsed since game started
    var timeElapsed: TimeInterval { get }

    /// Starts the countdown timer
    func startTimer(timerInterval: TimeInterval, viewControllerDelegate: BaseGameViewControllerDelegate?)

    init()

    init(totalTimeAllowed: TimeInterval)
}

extension TimedGameViewModel {

    /// Retrieves time elapsed since game started
    var timeElapsed: TimeInterval {
        return totalTimeAllowed - timeRemaining
    }

    init(totalTimeAllowed: TimeInterval) {
        self.init()
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
