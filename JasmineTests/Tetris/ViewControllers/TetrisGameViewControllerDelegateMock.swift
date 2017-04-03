import Foundation
@testable import Jasmine

class TetrisGameViewControllerDelegateMock: TetrisGameViewControllerDelegate {
    var score: Int?
    var timeRemaining: TimeInterval?
    var totalTime: TimeInterval!
    var gameStatusUpdated = false

    var fallingTileTextRedisplayed = false
    var upcomingTilesRedisplayed = false

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

    func redisplayUpcomingTiles() {
        upcomingTilesRedisplayed = true
    }

    func redisplayFallingTile(tileText: String) {
        fallingTileTextRedisplayed = true
    }

    func animate(destroyedTiles: Set<Coordinate>, shiftedTiles: [(from: Coordinate, to: Coordinate)]) {
    }
}
