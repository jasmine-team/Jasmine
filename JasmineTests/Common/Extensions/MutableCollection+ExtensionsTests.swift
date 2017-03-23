import XCTest
@testable import Jasmine

class MutableCollectionExtensionsTests: XCTestCase {

    private let iterations = 25

    func testShuffle() {
        let collection = [1, 2, 3]
        var lastElementMoved = false
        for _ in 0...iterations {
            let shuffled = collection.shuffled()
            lastElementMoved = lastElementMoved || collection.last == shuffled.last
            XCTAssertEqual(collection, shuffled.sorted(), "Elements were changed")
        }
        XCTAssertTrue(lastElementMoved, "Last element was not swapped")
    }

    func testEmptyShuffle() {
        XCTAssertEqual(0, [].shuffled().count, "Empty array shuffled is not empty")
    }
}
