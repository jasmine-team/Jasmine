import Foundation

/// A timer to handle game time
class CountDownTimer {
    /// Specifies the time remaining in the game.
    private(set) var timeRemaining: TimeInterval
    /// Specifies the total time allowed in the game.
    let totalTimeAllowed: TimeInterval
    /// The ViewModel that contains this timer.
    var viewModel: TimedViewModelProtocol?
    /// The ViewController of the ViewModel.
    var viewController: BaseGameViewControllerDelegate?

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
    func startTimer(timerInterval: TimeInterval) {
        assert(timerInterval >= 0, "timerInterval must be positive")

        viewModel?.gameStatus = .inProgress
        viewController?.redisplay(timeRemaining: timeRemaining, outOf: totalTimeAllowed)

        Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
            self.timeRemaining -= timerInterval
            self.viewController?.redisplay(timeRemaining: self.timeRemaining, outOf: self.totalTimeAllowed)

            if self.timeRemaining <= 0 {
                self.viewController?.notifyGameStatus()
                timer.invalidate()
            }
        }
    }
}
