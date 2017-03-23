import Foundation
@testable import Jasmine

class GridGameViewControllerDelegateMock: GridGameViewControllerDelegate {
    var gridDataUpdated = false
    var allTilesRedisplayed = false
    var tilesRedisplayed: Set<Coordinate> = []
    var score = 0
    var timeRemaining: TimeInterval = 0
    var totalTime: TimeInterval = 0
    var gameStatusUpdated = false

    func updateGridData() {
        gridDataUpdated = true
    }

    func redisplayAllTiles() {
        allTilesRedisplayed = true
    }

    func redisplay(tileAt coordinate: Coordinate) {
        tilesRedisplayed.formUnion([coordinate])
    }

    func redisplay(tilesAt coordinates: Set<Coordinate>) {
        tilesRedisplayed.formUnion(coordinates)
    }

    func redisplay(newScore: Int) {
        score = newScore
    }

    func redisplay(timeRemaining: TimeInterval, outOf totalTime: TimeInterval) {
        self.timeRemaining = timeRemaining
        self.totalTime = totalTime
    }

    func updateGameStatus() {
        gameStatusUpdated = true
    }
}
