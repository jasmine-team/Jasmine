import XCTest
@testable import Jasmine

class PhraseViewModelTests: XCTestCase {
    func testInit() {
        guard let gameData = try? GameDataFactory().createGame(difficulty: 0, type: .ciHui) else {
            XCTFail("Realm errors")
            return
        }

        for phrase in gameData.phrases.next(count: 10) {
            let viewModel = PhraseViewModel(phrase: phrase)
            XCTAssertEqual(phrase.chinese.joined(), viewModel.hanZi)
            XCTAssertEqual(phrase.pinyin.joined(separator: " "), viewModel.pinYin)
            XCTAssertEqual(phrase.english, viewModel.english)
            XCTAssertEqual(phrase.chinese.joined(), viewModel.speech.speechString)
            XCTAssertEqual("zh-CN", viewModel.speech.voice?.language)
        }
    }
}
