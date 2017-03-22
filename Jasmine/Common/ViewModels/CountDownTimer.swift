import Foundation

/// A timer to handle game time
class CountDownTimer {
    typealias VMProtocol = (TimedViewModelProtocol & BaseViewModelProtocol)

    /// The ViewModel that contains this timer.
    private weak var viewModel: VMProtocol?
    /// Specifies the total time allowed in the game.
    let totalTimeAllowed: TimeInterval
    /// Specifies the time remaining in the game.
    private(set) var timeRemaining: TimeInterval {
        didSet {
            viewModel?.timeDidUpdate(timeRemaining: timeRemaining, totalTime: totalTimeAllowed)
        }
    }

    /// Initialize the total time allowed and sets timeRemaining to it
    init(totalTimeAllowed: TimeInterval, viewModel: VMProtocol?) {
        assert(totalTimeAllowed >= 0, "totalTimeAllowed must be positive")
        self.viewModel = viewModel
        self.totalTimeAllowed = totalTimeAllowed
        timeRemaining = totalTimeAllowed
        // Need to include this on init only
        viewModel?.timeDidUpdate(timeRemaining: timeRemaining, totalTime: totalTimeAllowed)
    }

    /// Starts the countdown timer
    func startTimer(timerInterval: TimeInterval) {
        assert(timerInterval >= 0, "timerInterval must be positive")

        viewModel?.gameStatus = .inProgress

        Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
            self.timeRemaining -= timerInterval

            if self.timeRemaining <= 0 {
                self.viewModel?.gameStatus = .endedWithLost
                timer.invalidate()
            }
        }
    }
}
