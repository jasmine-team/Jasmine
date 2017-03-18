import XCTest
@testable import Jasmine

class TimedGameViewModelTest: XCTestCase {

    private let totalTimeAllowed: TimeInterval = 10
    private var gameViewModel: TimedGameViewModel! // initialized in setUp

    override func setUp() {
        super.setUp()

        gameViewModel = TimedGameViewModel(totalTimeAllowed: totalTimeAllowed)
    }

    func testTotalTimeAllowed() {
        XCTAssertEqual(gameViewModel.totalTimeAllowed, totalTimeAllowed, "Total time allowed is wrong")
    }

    func testTimeRemaining() {
        XCTAssertEqual(gameViewModel.timeRemaining, totalTimeAllowed, "Time remaining is wrong")
    }

    func testTimeElapsed() {
        XCTAssertEqual(gameViewModel.timeElapsed, 0, "Time elapsed is wrong")
    }
}
