import Foundation
@testable import Jasmine

class GridGameViewControllerDelegateMock: GridGameViewControllerDelegate {
    var gridDataUpdated = false
    var allTilesRedisplayed = false
    var score = 0
    var timeRemaining: TimeInterval = 0
    var totalTime: TimeInterval = 0
    var gameStatusUpdated = false
    var coordinatesRedisplayed = Set<Coordinate>()

    func updateGridData() {
        gridDataUpdated = true
    }

    func redisplayAllTiles() {
        allTilesRedisplayed = true
    }

    func redisplay(tilesAt tiles: Set<Coordinate>) {
        coordinatesRedisplayed.formUnion(tiles)
    }

    func redisplay(tileAt tile: Coordinate) {
        coordinatesRedisplayed.formUnion([tile])
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
