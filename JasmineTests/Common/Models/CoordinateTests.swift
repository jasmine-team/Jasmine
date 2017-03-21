import XCTest
@testable import Jasmine

class CoordinateTests: XCTestCase {

    func testOrigin() {
        XCTAssertEqual(Coordinate(row: 0, col: 0), Coordinate.origin, "Origin should be (0, 0)")
    }

    func testEquals() {
        XCTAssertEqual(Coordinate(row: 3, col: 5), Coordinate(row: 3, col: 5),
                       "Coordinates with same row and col should be equal")

        XCTAssertNotEqual(Coordinate(row: 3, col: 5), Coordinate(row: 2, col: 5),
                          "Coordinates with different row should not be equal")
        XCTAssertNotEqual(Coordinate(row: 3, col: 5), Coordinate(row: 3, col: 6),
                          "Coordinates with different col should not be equal")
        XCTAssertNotEqual(Coordinate(row: 3, col: 5), Coordinate(row: 5, col: 3),
                          "Coordinates with different col should not be equal")
    }

    func testHashValue() {
        // Note that not equal is not tested due to possible hash collisions.

        XCTAssertEqual(Coordinate(row: 3, col: 5).hashValue, Coordinate(row: 3, col: 5).hashValue,
                       "Coordinates with same row and col should be equal")

        XCTAssertEqual(Coordinate(row: 5, col: 3).hashValue, Coordinate(row: 5, col: 3).hashValue,
                       "Coordinates with same row and col should be equal")
    }

    func testGetNextRow() {
        XCTAssertEqual(Coordinate(row: 3, col: 5).nextRow, Coordinate(row: 4, col: 5),
                       "getNextRow did not return the correct coordinates")

    }
}
