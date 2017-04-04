import Foundation
@testable import Jasmine

class TetrisGameViewControllerMock {

    var scoreUpdated = false
    var timeUpdated = false
    var gameStatusUpdated = false
}

extension TetrisGameViewControllerMock: ScoreUpdateDelegate {
    func scoreDidUpdate() {
        scoreUpdated = true
    }
}

extension TetrisGameViewControllerMock: TimeUpdateDelegate {
    func timeDidUpdate() {
        timeUpdated = true
    }
}

extension TetrisGameViewControllerMock: GameStatusUpdateDelegate {
    func gameStatusDidUpdate() {
        gameStatusUpdated = true
    }
}
