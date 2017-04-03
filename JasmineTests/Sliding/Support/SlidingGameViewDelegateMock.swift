import Foundation
@testable import Jasmine

class SlidingGameViewControllerDelegateMock: SlidingGameViewControllerDelegate {
    var score = 0
    var timeRemaining: TimeInterval = 0
    var totalTime: TimeInterval = 0
    var gameStatusUpdated = false

    func redisplay(newScore: Int) {
        score = newScore
    }

    func redisplay(timeRemaining: TimeInterval, outOf totalTime: TimeInterval) {
        self.timeRemaining = timeRemaining
        self.totalTime = totalTime
    }

    func notifyGameStatusUpdated() {
        gameStatusUpdated = true
    }
}
