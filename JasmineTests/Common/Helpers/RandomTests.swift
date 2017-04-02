import XCTest
@testable import Jasmine

class RandomTests: XCTestCase {

    private let iterations = 10

    func testMultiple(function: () -> Void) {
        for _ in 0...iterations {
            function()
        }
    }

    func testIntegerInclusive() {
        testMultiple {
            let result = Random.integer(from: 0, toInclusive: 1)
            XCTAssertTrue(result == 0 || result == 1, "Int generated is not within range")
        }
    }

    func testIntegerInclusiveDefaultFrom() {
        testMultiple {
            let result = Random.integer(toInclusive: 1)
            XCTAssertTrue(result == 0 || result == 1, "Int generated is not within range")
        }
    }

    func testIntegerExclusive() {
        testMultiple {
            let result = Random.integer(from: 0, toExclusive: 2)
            XCTAssertTrue(result == 0 || result == 1, "Int generated is not within range")
        }
    }

    func testDouble() {
        testMultiple {
            let result = Random.double(from: 0, toInclusive: 1)
            XCTAssertTrue(result >= 0 && result <= 1, "Double generated is not within range")
        }
    }
}
