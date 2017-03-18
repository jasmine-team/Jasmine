import XCTest
@testable import Jasmine

class TimedGameViewModelMock: TimedGameViewModel {
    /// Specifies the total time allowed in the game.
    var totalTimeAllowed: TimeInterval

    /// Specifies the time remaining in the game.
    var timeRemaining: TimeInterval

    init() {
        totalTimeAllowed = 0
        timeRemaining = 0
    }
}

class TimedGameViewModelTest: XCTestCase {

    func testTimeElapsed() {
        let gameViewModel = TimedGameViewModelMock()
        let testCases: [(TimeInterval, TimeInterval)] = [(0, 0), (2, 2), (5, 3), (100, 7), (10.7, 3.3)]

        for (totalTime, timeRemaining) in testCases {
            gameViewModel.totalTimeAllowed = totalTime
            gameViewModel.timeRemaining = timeRemaining
            XCTAssertEqual(gameViewModel.timeElapsed, totalTime - timeRemaining,
                           "Time elapsed is not totalTime - timeRemaining")
        }
    }

    func testStartTimer() {
        // TODO
    }
}
