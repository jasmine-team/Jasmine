import XCTest
@testable import Jasmine

class RandomTests: XCTestCase {

    private let iterations = 10

    func testMultiple(times: Int, function: () -> Void) {
        for _ in 0...times {
            function()
        }
    }

    func testRandom_int() {
        testMultiple(times: iterations) {
            let result = Random.integer(from: 0, toInclusive: 1)
            XCTAssertTrue(result == 0 || result == 1, "Int generated is not within range")
        }
    }

    func testRandom_intDefaultFrom() {
        testMultiple(times: iterations) {
            let result = Random.integer(toInclusive: 1)
            XCTAssertTrue(result == 0 || result == 1, "Int generated is not within range")
        }
    }

    func testRandom_double() {
        testMultiple(times: iterations) {
            let result = Random.double(from: 0, toInclusive: 1)
            XCTAssertTrue(result >= 0 && result <= 1, "Double generated is not within range")
        }
    }
}
