import XCTest
@testable import Jasmine

class MutableCollectionExtensionsTests: XCTestCase {

    private let iterations = 10

    func testShuffle() {
        let collection = [1, 2, 3]
        var lastElementMoved = false
        for _ in 0...iterations {
            let shuffled = collection.shuffled()
            lastElementMoved = lastElementMoved || collection[2] == shuffled[2]
            XCTAssertEqual(collection, shuffled.sorted(), "Elements were changed")
        }
        XCTAssertTrue(lastElementMoved, "Last element was not swapped")
    }
}
