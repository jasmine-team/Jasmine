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

    func testToIndex() {
        XCTAssertEqual(Coordinate(row: 0, col: 0).toIndex(withNumCol: 1), 0,
                       "Index for this coordinate should be equal.")

        XCTAssertEqual(Coordinate(row: 10, col: 0).toIndex(withNumCol: 1), 10,
                       "Index for this coordinate should be equal.")

        XCTAssertEqual(Coordinate(row: 0, col: 0).toIndex(withNumCol: 5), 0,
                       "Index for this coordinate should be equal.")

        XCTAssertEqual(Coordinate(row: 0, col: 4).toIndex(withNumCol: 5), 4,
                       "Index for this coordinate should be equal.")

        XCTAssertEqual(Coordinate(row: 3, col: 0).toIndex(withNumCol: 5), 15,
                       "Index for this coordinate should be equal.")

        XCTAssertEqual(Coordinate(row: 3, col: 1).toIndex(withNumCol: 5), 16,
                       "Index for this coordinate should be equal.")

        XCTAssertEqual(Coordinate(row: 3, col: 3).toIndex(withNumCol: 5), 18,
                       "Index for this coordinate should be equal.")

        XCTAssertEqual(Coordinate(row: 3, col: 4).toIndex(withNumCol: 5), 19,
                       "Index for this coordinate should be equal.")
    }

    func testInit_fromIndex() {
        XCTAssertEqual(Coordinate(index: 0, withNumCol: 1), Coordinate(row: 0, col: 0),
                       "Coordinate for this combination of index and numCol is incorrect.")

        XCTAssertEqual(Coordinate(index: 10, withNumCol: 1), Coordinate(row: 10, col: 0),
                       "Coordinate for this combination of index and numCol is incorrect.")

        XCTAssertEqual(Coordinate(index: 0, withNumCol: 5), Coordinate(row: 0, col: 0),
                       "Coordinate for this combination of index and numCol is incorrect.")

        XCTAssertEqual(Coordinate(index: 4, withNumCol: 5), Coordinate(row: 0, col: 4),
                       "Coordinate for this combination of index and numCol is incorrect.")

        XCTAssertEqual(Coordinate(index: 15, withNumCol: 5), Coordinate(row: 3, col: 0),
                       "Coordinate for this combination of index and numCol is incorrect.")

        XCTAssertEqual(Coordinate(index: 16, withNumCol: 5), Coordinate(row: 3, col: 1),
                       "Coordinate for this combination of index and numCol is incorrect.")

        XCTAssertEqual(Coordinate(index: 18, withNumCol: 5), Coordinate(row: 3, col: 3),
                       "Coordinate for this combination of index and numCol is incorrect.")

        XCTAssertEqual(Coordinate(index: 19, withNumCol: 5), Coordinate(row: 3, col: 4),
                       "Coordinate for this combination of index and numCol is incorrect.")
    }
}
