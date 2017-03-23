import Foundation

/// A timer to handle game time
class CountDownTimer {
    /// Specifies the total time allowed in the game.
    let totalTimeAllowed: TimeInterval
    /// Specifies the time remaining in the game.
    private(set) var timeRemaining: TimeInterval
    /// The timer of this countdown timer.
    private var timer: Timer?

    /// Function that is fired when timer is started.
    var timerDidStart: (() -> Void)?
    /// Function that is fired when timer has ticked.
    var timerDidTick: (() -> Void)?
    /// Function that is fired when timer is finished (timeRemaining <= 0).
    var timerDidFinish: (() -> Void)?
    /// Function that is fired when timer has stopped.
    var timerDidStop: (() -> Void)?

    /// Initialize the total time allowed and sets timeRemaining to it
    init(totalTimeAllowed: TimeInterval) {
        assert(totalTimeAllowed >= 0, "totalTimeAllowed must be positive")
        self.totalTimeAllowed = totalTimeAllowed
        timeRemaining = totalTimeAllowed
    }

    /// Starts the countdown timer
    func startTimer(timerInterval: TimeInterval) {
        assert(timerInterval >= 0, "timerInterval must be positive")
        timerDidStart?()

        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
            self.timeRemaining -= timerInterval
            self.timerDidTick?()

            if self.timeRemaining <= 0 {
                timer.invalidate()
                self.timerDidFinish?()
            }
        }
    }

    /// Stops the countdown timer
    func stopTimer() {
        guard let timer = timer else {
            fatalError("Timer is stopped when it has not started")
        }

        timer.invalidate()
        timerDidStop?()
    }
}
