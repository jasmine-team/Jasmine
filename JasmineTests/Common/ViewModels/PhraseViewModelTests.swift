import XCTest
@testable import Jasmine

class PhraseViewModelTests: RealmTestCase {
    func testInit() {
        let gameData = createGameData(difficulty: 1, type: .ciHui)

        for phrase in gameData.phrases.randomGenerator.next(count: 10) {
            let viewModel = PhraseViewModel(phrase: phrase)
            XCTAssertEqual(phrase.chinese.joined(), viewModel.hanZi)
            XCTAssertEqual(phrase.pinyin.joined(separator: " "), viewModel.pinYin)
            XCTAssertEqual(phrase.english, viewModel.english)
            XCTAssertEqual(phrase.chinese.joined(), viewModel.speech.speechString)
            XCTAssertEqual("zh-CN", viewModel.speech.voice?.language)
        }
    }
}
