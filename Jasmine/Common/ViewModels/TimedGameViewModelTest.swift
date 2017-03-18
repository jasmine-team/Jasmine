import XCTest
@testable import Jasmine

class TimedGameViewModelTest: XCTestCase {

    private let totalTimeAllowed: TimeInterval = 10

    func testInit() {
        let gameViewModel = TimedGameViewModel(totalTimeAllowed: totalTimeAllowed)
        XCTAssertEqual(gameViewModel.totalTimeAllowed, totalTimeAllowed, "Total time allowed in init is wrong")
        XCTAssertEqual(gameViewModel.timeRemaining, totalTimeAllowed, "Time remaining in init is wrong")
        XCTAssertEqual(gameViewModel.timeElapsed, 0, "Time elapsed in init is wrong")
    }
}
