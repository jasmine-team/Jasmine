import XCTest
@testable import Jasmine

class IndexPathCoordinateTests: XCTestCase {

    func testConvertBetweenCoordinate() {
        /// Helper test for conversions.
        func testHelper(for coordinate: Coordinate) {
            let indexPath = IndexPath(coordinate)
            XCTAssertEqual(indexPath.toCoordinate, coordinate, "The returned coordinate should equate")
        }

        testHelper(for: Coordinate(row: 0, col: 0))
        testHelper(for: Coordinate(row: 0, col: 1))
        testHelper(for: Coordinate(row: 0, col: 2))
        testHelper(for: Coordinate(row: 5, col: 0))
        testHelper(for: Coordinate(row: 5, col: 5))
    }

}
