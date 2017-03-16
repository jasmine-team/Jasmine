import XCTest
@testable import Jasmine

class CoordinateTests: XCTestCase {
    func testOrigin() {
        XCTAssertEqual(Coordinate(row: 0, col: 0), Coordinate.origin, "Origin should be (0, 0)")
    }

    func testCoordinateEquals() {
        XCTAssertEqual(Coordinate(row: 3, col: 5), Coordinate(row: 3, col: 5),
                       "Coordinates with same row and col should be equal")
        XCTAssertNotEqual(Coordinate(row: 3, col: 5), Coordinate(row: 2, col: 5),
                          "Coordinates with different row should not be equal")
        XCTAssertNotEqual(Coordinate(row: 3, col: 5), Coordinate(row: 3, col: 6),
                          "Coordinates with different col should not be equal")
    }
}
