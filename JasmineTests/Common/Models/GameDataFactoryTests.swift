import XCTest
@testable import Jasmine

class GameDataFactoryTests: RealmTestCase {

    var gameDataFactory: GameDataFactory!

    override func setUp() {
        super.setUp()
        gameDataFactory = GameDataFactory(realm: realm)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGameDataFactory_createGame_ciHui() {
        let phrases = [
            Phrase(value: ["chinese": "中文"]),
            Phrase(value: ["chinese": "刷新"]),
            Phrase(value: ["chinese": "脱颖而出"]),
        ]
        testGameDataFactory_createGame_generic(phrases: phrases, type: .ciHui, count: 2)
    }

    func testGameDataFactory_createPhrases_chengYu() {
        let phrases = [
            Phrase(value: ["chinese": "刷新"]),
            Phrase(value: ["chinese": "脱颖而出"]),
            Phrase(value: ["chinese": "马马虎虎"]),
        ]
        testGameDataFactory_createGame_generic(phrases: phrases, type: .chengYu, count: 2)
    }

    /// Tests createGame generically
    ///
    /// - Parameters:
    ///   - phrases: list of phrases to persist in the realm db
    ///   - type: GameType for factory to generate
    ///   - count: actual number of results in assert against
    private func testGameDataFactory_createGame_generic(phrases: [Phrase],
                                                        type: GameType,
                                                        count: Int) {
        phrases.forEach(save)
        let difficulty = 1
        let gameData = gameDataFactory.createGame(difficulty: difficulty, type: type)
        let result = Set(gameData.phrases.prefix(phrases.count))
        XCTAssertEqual(result.count, count, "game phrases is incorrect")
        XCTAssertEqual(gameData.difficulty, difficulty, "game difficulty is incorrect")
    }

}
