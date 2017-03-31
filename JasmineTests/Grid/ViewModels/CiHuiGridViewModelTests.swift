import XCTest
@testable import Jasmine

class CiHuiGridViewModelTests: XCTestCase {
    func testInit() {
        let numberOfPhrases = 3

        guard let gameData = try? GameDataFactory().createGame(difficulty: 5, type: .ciHui) else {
            XCTFail("Realm errors")
            return
        }

        let viewModel = CiHuiGridViewModel(time: 10, gameData: gameData, numberOfPhrases: numberOfPhrases)

        let phrases = gameData.phrases.prefix(numberOfPhrases)
        var tiles: [String] = []
        for phrase in phrases {
            let hanzi = phrase.chinese.characters.map { String($0) }
            let pinyin = phrase.pinyin.components(separatedBy: " ")
            tiles += (hanzi + pinyin)
        }

        XCTAssertEqual(Set(tiles), Set(viewModel.gridData.values),
                       "ViewModel tiles on init is not correct")
        XCTAssertNil(viewModel.delegate,
                     "ViewModel delegate on init is not nil")
        XCTAssertEqual(0, viewModel.currentScore,
                       "ViewModel currentScore on init is not zero")
        XCTAssertEqual(3, viewModel.numRows,
                       "ViewModel rows on init is not correct")
        XCTAssertEqual(4, viewModel.numColumns,
                       "ViewModel columns on init is not correct")
        XCTAssertEqual(10, viewModel.timeRemaining,
                       "ViewModel timeRemaining on init is not correct")
        XCTAssertEqual(10, viewModel.totalTimeAllowed,
                       "ViewModel timeRemaining on init is not correct")
        XCTAssertEqual(GameStatus.notStarted, viewModel.gameStatus,
                       "ViewModel gameStatus on init is not correct")
        XCTAssertEqual("Ci Hui (词汇) Grid Game", viewModel.gameTitle,
                       "ViewModel gameTitle on init is not correct")
        XCTAssertEqual("Match the Chinese characters with their Pinyins by putting them in one row.",
                       viewModel.gameInstruction,
                       "ViewModel gameInstruction on init is not correct")
    }
}
