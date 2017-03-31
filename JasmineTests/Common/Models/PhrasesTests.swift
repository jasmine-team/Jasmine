import XCTest
@testable import Jasmine

class PhrasesTests: RealmTestCase {

    func testGameData_phrases_contains() {
        let listOfPhrases = [
            Phrase(value: ["chinese": "中文"]),
            Phrase(value: ["chinese": "汉语"]),
            Phrase(value: ["chinese": "电脑"]),
        ]
        listOfPhrases.forEach(save)
        let phraseResults = realm.objects(Phrase.self)
        let phrases = Phrases(phraseResults, range: 0..<phraseResults.count)
        XCTAssertFalse(phrases.contains(chinese: ""), "Empty string found within phrases")
        XCTAssertFalse(phrases.contains(chinese: "中"), "Partial string found within phrases")
        XCTAssertTrue(phrases.contains(chinese: "中文"), "String not found within phrases")
    }

}
