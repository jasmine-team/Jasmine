import Foundation

/// A timer to handle game time
class CountDownTimer {
    /// Specifies the total time allowed in the game.
    let totalTimeAllowed: TimeInterval
    /// Specifies the time remaining in the game.
    private(set) var timeRemaining: TimeInterval
    /// The timer of this countdown timer.
    private var timer: Timer?
    /// A listener to this timer that is fired depending on the timer status.
    var timerListener: ((TimerStatus) -> Void) = { _ in }

    /// Initialize the total time allowed and sets timeRemaining to it
    init(totalTimeAllowed: TimeInterval) {
        assert(totalTimeAllowed >= 0, "totalTimeAllowed must be positive")
        self.totalTimeAllowed = totalTimeAllowed
        timeRemaining = totalTimeAllowed
    }

    /// Starts the countdown timer
    func startTimer(timerInterval: TimeInterval) {
        assert(timerInterval >= 0, "timerInterval must be positive")
        timerListener(.start)

        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
            self.timeRemaining -= timerInterval
            self.timerListener(.tick)

            if self.timeRemaining <= 0 {
                timer.invalidate()
                self.timerListener(.finish)
            }
        }
    }

    /// Stops the countdown timer
    func stopTimer() {
        guard let timer = timer else {
            fatalError("Timer is stopped when it has not started")
        }

        timer.invalidate()
        timerListener(.stop)
    }
}
