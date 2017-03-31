import XCTest
@testable import Jasmine

class PhrasesTests: RealmTestCase {

    let listOfPhrases = [
        Phrase(value: ["chinese": "中文"]),
        Phrase(value: ["chinese": "汉语"]),
        Phrase(value: ["chinese": "电脑"]),
    ]
    var phrases: Phrases!

    override func setUp() {
        super.setUp()
        listOfPhrases.forEach(save)
        let phraseResults = realm.objects(Phrase.self)
        phrases = Phrases(phraseResults, range: 0..<phraseResults.count)
    }

    func testPhrases_next() {
        let resultingPhrases = (0..<10).map { _ in
            phrases.next()
        }
        XCTAssertEqual(Set(listOfPhrases), Set(resultingPhrases), "next does not return input variables")
    }

    func testPhrases_of() {
        let length = 4
        let resultingPhrases = phrases.next(count: 4)
        XCTAssertEqual(resultingPhrases.count, length, "length of array returned is incorrect")
    }

    func testPhrases_contains() {
        XCTAssertFalse(phrases.contains(chinese: ""), "Empty string found within phrases")
        XCTAssertFalse(phrases.contains(chinese: "中"), "Partial string found within phrases")
        XCTAssertTrue(phrases.contains(chinese: "中文"), "String not found within phrases")
    }

}
