import Foundation

/// A ViewModel that implements a timer, i.e. it is timed.
protocol TimedViewModelProtocol: class {
    /// The timer of the ViewModel
    var timer: CountDownTimer { get }
    /// Specifies the total time allowed in the game.
    var totalTimeAllowed: TimeInterval { get }
    /// Specifies the remaining time left in the game.
    var timeRemaining: TimeInterval { get }
}

extension TimedViewModelProtocol {
    var totalTimeAllowed: TimeInterval {
        return timer.totalTimeAllowed
    }

    var timeRemaining: TimeInterval {
        return timer.timeRemaining
    }
}
