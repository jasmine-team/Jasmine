import Foundation

/// A ViewModel that implements a timer, i.e. it is timed.
protocol CountdownTimable {
    /// Specifies the total time allowed in the game.
    var totalTimeAllowed: TimeInterval { get }
    /// Specifies the remaining time left in the game.
    var timeRemaining: TimeInterval { get }
}
