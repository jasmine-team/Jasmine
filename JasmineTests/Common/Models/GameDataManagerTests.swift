import XCTest
@testable import Jasmine

class GameDataManagerTests: RealmTestCase {

    var gameDataManager: GameDataManager!

    override func setUp() {
        super.setUp()
        gameDataManager = GameDataManager(realm: realm)
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGameDataManager_createGame() {
        let difficulty = 1
        let gameData = gameDataManager.createGame(difficulty: difficulty)
        XCTAssertEqual(gameData.difficulty, difficulty, "game difficulty is incorrect")
    }

}
