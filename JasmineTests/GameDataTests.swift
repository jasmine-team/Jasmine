import XCTest
@testable import Jasmine

class GameDataTests: RealmTestCase {

    var gameData: GameData!

    override func setUp() {
        super.setUp()
        gameData = GameData(instance: realm)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGameData_initialization() {
        XCTAssertEqual(gameData.score, 0, "game score should be zero at start")
    }

    func testGameData_phrases() {
        let phrase = Phrase()
        save(phrase)
        XCTAssertEqual(gameData.phrases.count, 1, "game data could not find relevant phrase")
    }

}
