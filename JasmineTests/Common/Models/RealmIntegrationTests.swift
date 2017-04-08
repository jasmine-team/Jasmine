import XCTest
@testable import Jasmine

/// Unlike other tests that involves realm, this uses the real db to ensure it is usuable
class RealmIntegrationTests: XCTestCase {

    var factory: GameManager!

    override func setUp() {
        super.setUp()
        do {
            factory = try GameManager()
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testRealm_phrases() {
        let gameTypes: [GameType] = [.chengYu, .ciHui]
        gameTypes.forEach { type in
            let level = Level()
            level.gameType = type
            let gameData = factory.createGame(fromLevel: level)
            XCTAssertNotNil(gameData.phrases.next(), "Game data does not contain phrases")
            XCTAssertEqual(gameData.phrases.next(count: 5).count, 5, "Incorrect amount of phrases")
        }
    }

}
