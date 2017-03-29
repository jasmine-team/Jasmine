import XCTest
@testable import Jasmine

class ArrayExtensionsTests: XCTestCase {
    func testIsSubsequenceOf() {
        let array = [1, 2, 3]

        for startElem in 0..<3 {
            for endElem in startElem..<3 {
                let subArray = Array(array[startElem...endElem])
                XCTAssert(subArray.isSubsequenceOf(array), "\(subArray) is not subsequence of [1, 2, 3]")
            }
        }

        XCTAssertFalse([1, 3].isSubsequenceOf(array),
                       "[1, 3] is subsequence of [1, 2, 3]")
        XCTAssertFalse([4].isSubsequenceOf(array),
                       "[4] is subsequence of [1, 2, 3]")
    }
}
