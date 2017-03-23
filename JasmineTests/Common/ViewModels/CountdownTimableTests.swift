import XCTest
@testable import Jasmine

class CountdownTimableTests: XCTestCase {
    func testDefaults() {
        let timable = CountdownTimableMock()

        XCTAssertEqual(timable.timer.timeRemaining, timable.timeRemaining,
                       "CountdownTimable default timeRemaining is not correct")
        XCTAssertEqual(timable.timer.totalTimeAllowed, timable.totalTimeAllowed,
                       "CountdownTimable default totalTimeAllowed is not correct")
    }
}
