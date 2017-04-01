import XCTest
@testable import Jasmine

/// Test cases for getting the direction
class UISwipeGestureRecognizerDirectionTests: XCTestCase {

    func testGetDirection() {
        XCTAssertEqual(UISwipeGestureRecognizerDirection.up.toDirection, Direction.northwards,
                       "Should be northwards.")

        XCTAssertEqual(UISwipeGestureRecognizerDirection.down.toDirection, Direction.southwards,
                       "Should be southwards.")

        XCTAssertEqual(UISwipeGestureRecognizerDirection.left.toDirection, Direction.westwards,
                       "Should be westwards.")

        XCTAssertEqual(UISwipeGestureRecognizerDirection.right.toDirection, Direction.eastwards,
                       "Should be eastwards.")
    }
}
