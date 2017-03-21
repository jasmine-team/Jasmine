import XCTest
@testable import Jasmine

class SequenceExtensionsTests: XCTestCase {
    func testHasNoDuplicates() {
        let emptyArray: [Int] = []

        XCTAssert(emptyArray.isAllSame, "Empty array should be is all same")
        XCTAssert([1].isAllSame, "Array with 1 elem should has all same elements")
        XCTAssert([1, 1, 1].isAllSame, "The array [1, 1, 1] should has all same elements")
        XCTAssertFalse([1, 1, 3].isAllSame, "The array [1, 1, 3] should not all has same")
        XCTAssertFalse([1, 2, 3].isAllSame, "The array [1, 1, 3] should not all has same")
    }
}
