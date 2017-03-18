import XCTest
@testable import Jasmine

class GameDataTests: RealmTestCase {

    var gameData: GameData!

    override func setUp() {
        super.setUp()
        gameData = GameData()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGameData_initialization() {
        XCTAssertEqual(gameData.score, 0, "game score should be zero at start")
    }

    func testGameData_phrases() {
        save(Phrase())
        gameData.phrases = realm.objects(Phrase.self)
        XCTAssertEqual(gameData.phrases.count, 1, "game data could not find relevant phrase")
    }

}
