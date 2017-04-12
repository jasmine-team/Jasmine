import XCTest
@testable import Jasmine

class LevelErrorTests: XCTestCase {

    func testErrorDescription() {
        XCTAssertEqual("Duplicate level name: Bad Level", LevelsError.duplicateLevelName("Bad Level").errorDescription)
        XCTAssertEqual("No phrase selected", LevelsError.noPhraseSelected.errorDescription)
    }
}
