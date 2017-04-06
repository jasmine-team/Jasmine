import XCTest
@testable import Jasmine

class PhraseTests: RealmTestCase {

    func testPhrases_calculatedProperties() {
        let phrase = Phrase(value: ["chinese": "中文", "pinyin": "zhong wen"])
        XCTAssertEqual(phrase.chinese, ["中", "文"], "Chinese is not split correctly")
        XCTAssertEqual(phrase.pinyin, ["zhong", "wen"], "Pin yin is not split correctly")
    }

}
