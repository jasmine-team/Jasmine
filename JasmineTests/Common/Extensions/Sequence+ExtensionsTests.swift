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

    func testIsAllTrue() {
        let emptyArray: [Int] = []

        XCTAssert([2, 4, 6].isAllTrue(predicate: { $0 % 2 == 0 }))
        XCTAssertFalse([2, 4, 5].isAllTrue(predicate: { $0 % 2 == 0 }))
        XCTAssertFalse([2, 3, 5].isAllTrue(predicate: { $0 % 2 == 0 }))
        XCTAssertFalse([1, 3, 5].isAllTrue(predicate: { $0 % 2 == 0 }))
        XCTAssert(emptyArray.isAllTrue(predicate: { $0 % 2 == 0 }))
        XCTAssert([2].isAllTrue(predicate: { $0 % 2 == 0 }))
    }
}
