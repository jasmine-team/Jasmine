import Foundation
@testable import Jasmine

class SwappingGameViewControllerDelegateMock: SwappingGameViewControllerDelegate {
    var gridDataUpdated = false
    var score = 0
    var timeRemaining: TimeInterval = 0
    var totalTime: TimeInterval = 0
    var gameStatusUpdated = false

    func updateGridData() {
        gridDataUpdated = true
    }

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
