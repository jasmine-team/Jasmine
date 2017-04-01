import XCTest
@testable import Jasmine

class IndexPathCoordinateTests: XCTestCase {

    func testConvertBetweenCoordinate() {
        /// Helper test for conversions.
        func testHelper(row: Int, col: Int) {
            let indexPath = IndexPath(item: col, section: row)
            let coordinate = Coordinate(row: row, col: col)
            XCTAssertEqual(indexPath.toCoordinate, coordinate, "The returned coordinate should equate")
        }

        testHelper(row: 0, col: 0)
        testHelper(row: 0, col: 1)
        testHelper(row: 0, col: 2)
        testHelper(row: 5, col: 0)
        testHelper(row: 5, col: 5)
    }

}
