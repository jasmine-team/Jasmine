import XCTest
@testable import Jasmine

class PhrasesTests: RealmTestCase {

    let listOfPhrases = [
        Phrase(value: ["rawChinese": "中文"]),
        Phrase(value: ["rawChinese": "汉语"]),
        Phrase(value: ["rawChinese": "电脑"]),
    ]
    var phrases: Phrases!

    override func setUp() {
        super.setUp()
        listOfPhrases.forEach(save)
        let phraseResults = realm.objects(Phrase.self)
        guard let phraseLength = listOfPhrases.first?.chinese.count else {
            fatalError("Failed to get phrase length")
        }
        phrases = Phrases(phraseResults, range: 0..<phraseResults.count, phraseLength: phraseLength)
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

    func testPhrases_first() {
        XCTAssertNil(phrases.first(whereChinese: ""), "Empty string found within phrases")
        XCTAssertNil(phrases.first(whereChinese: "中"), "Partial string found within phrases")
        XCTAssertEqual(phrases.first(whereChinese: "中文"), listOfPhrases.first,
                       "String not found within phrases")
    }

}
