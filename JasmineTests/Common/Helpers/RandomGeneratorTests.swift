import XCTest
@testable import Jasmine

class RandomGeneratorTests: XCTestCase {

    func testNext() {
        let seed = [1, 2, 3]
        let generator = seed.randomGenerator
        let results = (0..<10).map { _ in
            generator.next()
        }
        XCTAssertEqual(Set(results), Set(seed), "Seed was not iterated over")
    }

    func testNextCount() {
        let seed = [1, 2, 3]
        let generator = seed.randomGenerator
        let results = generator.next(count: 10)
        XCTAssertEqual(Set(results), Set(seed), "Seed was not iterated over")
    }

}
