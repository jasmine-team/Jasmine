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

    func testNextRow() {
        XCTAssertEqual(Coordinate(row: 3, col: 5).nextRow, Coordinate(row: 4, col: 5),
                       "nextRow did not return the correct coordinates")
    }

    func testPreviousRow() {
        XCTAssertEqual(Coordinate(row: 3, col: 5).prevRow, Coordinate(row: 2, col: 5),
                       "nextRow did not return the correct coordinates")
    }

    func testNextColumn() {
        XCTAssertEqual(Coordinate(row: 3, col: 5).nextCol, Coordinate(row: 3, col: 6),
                       "nextRow did not return the correct coordinates")
    }

    func testPreviousColumn() {
        XCTAssertEqual(Coordinate(row: 3, col: 5).prevCol, Coordinate(row: 3, col: 4),
                       "nextRow did not return the correct coordinates")
    }

    func testConvertToIndexPath() {
        /// Helper test for conversions.
        func testHelper(row: Int, col: Int) {
            let indexPath = IndexPath(item: col, section: row)
            let coordinate = Coordinate(row: row, col: col)
            XCTAssertEqual(coordinate.toIndexPath, indexPath, "The returned index path should equate")
        }

        testHelper(row: 0, col: 0)
        testHelper(row: 0, col: 1)
        testHelper(row: 0, col: 2)
        testHelper(row: 5, col: 0)
        testHelper(row: 5, col: 5)
    }

    func testIsWithinBound() {
        XCTAssertTrue(Coordinate(row: 0, col: 0).isWithin(numRows: 1, numCols: 1),
                      "This coordinate should be found within bounds")

        XCTAssertFalse(Coordinate(row: 1, col: 1).isWithin(numRows: 1, numCols: 1),
                      "This coordinate should not be found within bounds")

        XCTAssertFalse(Coordinate(row: 1, col: 0).isWithin(numRows: 1, numCols: 1),
                       "This coordinate should not be found within bounds")

        XCTAssertFalse(Coordinate(row: 0, col: 1).isWithin(numRows: 1, numCols: 1),
                       "This coordinate should not be found within bounds")

        XCTAssertTrue(Coordinate(row: 0, col: 0).isWithin(numRows: 10, numCols: 10),
                      "This coordinate should be found within bounds")

        XCTAssertTrue(Coordinate(row: 5, col: 6).isWithin(numRows: 10, numCols: 10),
                      "This coordinate should be found within bounds")

        XCTAssertTrue(Coordinate(row: 9, col: 9).isWithin(numRows: 10, numCols: 10),
                      "This coordinate should be found within bounds")

        XCTAssertFalse(Coordinate(row: 10, col: 10).isWithin(numRows: 10, numCols: 10),
                       "This coordinate should not be found within bounds")

        XCTAssertFalse(Coordinate(row: 10, col: 0).isWithin(numRows: 10, numCols: 10),
                       "This coordinate should not be found within bounds")

        XCTAssertFalse(Coordinate(row: 0, col: 10).isWithin(numRows: 10, numCols: 10),
                       "This coordinate should not be found within bounds")
    }

    func testComparable() {
        let coordinateArray = [(0, 0), (0, 1), (0, 2), (1, 0), (1, 1), (1, 2), (2, 0), (2, 1), (2, 2)]
        let sortedCoordinateArray = coordinateArray.sorted {
            Coordinate(row: $0.0, col: $0.1) < Coordinate(row: $1.0, col: $1.1)
        }

        for (original, sorted) in zip(coordinateArray, sortedCoordinateArray) {
            XCTAssertEqual(original.0, sorted.0,
                           "Coordinates are not sorted properly")
            XCTAssertEqual(original.1, sorted.1,
                           "Coordinates are not sorted properly")
        }
    }
}
