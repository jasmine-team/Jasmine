import XCTest
@testable import Jasmine

class DirectionTests: XCTestCase {

    func testIsHorizontal() {
        XCTAssertTrue(Direction.eastwards.isHorizontal)
        XCTAssertTrue(Direction.westwards.isHorizontal)
        XCTAssertFalse(Direction.northwards.isHorizontal)
        XCTAssertFalse(Direction.southwards.isHorizontal)
    }

    func testIsVertical() {
        XCTAssertFalse(Direction.eastwards.isVertical)
        XCTAssertFalse(Direction.westwards.isVertical)
        XCTAssertTrue(Direction.northwards.isVertical)
        XCTAssertTrue(Direction.southwards.isVertical)
    }
}
