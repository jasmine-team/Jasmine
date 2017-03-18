import Foundation

class GridViewModel: TimedGameViewModel {
    /// Specifies the total time allowed in the game.
    var totalTimeAllowed: TimeInterval

    /// Specifies the time remaining in the game.
    var timeRemaining: TimeInterval

    init() {
        totalTimeAllowed = 0
        timeRemaining = 0
    }
}
