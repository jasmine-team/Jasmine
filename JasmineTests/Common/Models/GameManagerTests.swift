import XCTest
@testable import Jasmine

class GameManagerTests: RealmTestCase {

    func testGameManager_createGame_ciHui() {
        let phrases = [
            Phrase(value: ["rawChinese": "中文"]),
            Phrase(value: ["rawChinese": "刷新"]),
        ]
        testGameManager_createGame_generic(phrases: phrases, type: .ciHui)
    }

    func testGameManager_createPhrases_chengYu() {
        let phrases = [
            Phrase(value: ["rawChinese": "脱颖而出"]),
            Phrase(value: ["rawChinese": "马马虎虎"]),
        ]
        testGameManager_createGame_generic(phrases: phrases, type: .chengYu)
    }

    /// Tests createGame generically
    ///
    /// - Parameters:
    ///   - phrases: list of phrases to persist in the realm db
    ///   - type: GameType for factory to generate
    ///   - count: actual number of results in assert against
    private func testGameManager_createGame_generic(phrases: [Phrase],
                                                    type: GameType) {
        let difficulty = 1
        let gameData = createGameData(phrases: phrases, difficulty: difficulty, type: type)
        let result = Set(gameData.phrases.next(count: phrases.count))
        XCTAssertEqual(result.count, phrases.count, "game phrases is incorrect")
        XCTAssertEqual(gameData.difficulty, difficulty, "game difficulty is incorrect")
    }

}
