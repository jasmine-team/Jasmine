import XCTest
@testable import Jasmine

class CountDownTimerTest: XCTestCase {

    func testInit() {
        let totalTimeAllowed = 10.5
        let timer = CountDownTimer(totalTimeAllowed: totalTimeAllowed)

        XCTAssertEqual(timer.totalTimeAllowed, totalTimeAllowed, "Total time allowed in init is wrong")
        XCTAssertEqual(timer.timeRemaining, totalTimeAllowed, "Time remaining in init is wrong")
        XCTAssertEqual(timer.timeElapsed, 0, "Time elapsed in init is wrong")
    }
}
