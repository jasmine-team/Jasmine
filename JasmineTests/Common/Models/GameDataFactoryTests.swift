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

    func testGameDataFactory_createGame() {
        save(Phrase())
        let difficulty = 1
        let gameData = gameDataFactory.createGame(difficulty: difficulty)
        XCTAssertEqual(gameData.difficulty, difficulty, "game difficulty is incorrect")
        XCTAssertEqual(gameData.phrases.count, 1, "game difficulty is incorrect")
    }

}
