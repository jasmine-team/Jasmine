import XCTest
@testable import Jasmine

class ArrayEquatableTests: XCTestCase {

    func testEquals() {
        let intArray: [Int] = [1, 2, 3]
        let intOptionalArray: [Int?] = [1, 2, 3]
        let intNilArray: [Int?] = [1, nil, 3]
        let emptyArray: [Int?] = []
        let longArray: [Int?] = [1, 2, 3, 4, 5, 6, 7]

        XCTAssert(intArray == intOptionalArray, "Array equals not correct")
        XCTAssert(!(intArray == intNilArray), "Array equals not correct")
        XCTAssert(!(intArray == emptyArray), "Array equals not correct")
        XCTAssert(!(intArray == longArray), "Array equals not correct")
        XCTAssert(intArray != intNilArray, "Array equals not correct")
        XCTAssert(intArray != emptyArray, "Array equals not correct")
        XCTAssert(intArray != longArray, "Array equals not correct")
    }
}
