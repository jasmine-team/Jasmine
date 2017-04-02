import XCTest
@testable import Jasmine

/// Unlike other tests that involves realm, this uses the real db to ensure it is usuable
class RealmIntegrationTests: XCTestCase {

    var factory: GameDataFactory!

    override func setUp() {
        super.setUp()
        do {
            factory = try GameDataFactory()
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testRealm_phrases() {
        let gameTypes: [GameType] = [.chengYu, .ciHui, .pinYin]
        gameTypes.forEach { type in
            let gameData = factory.createGame(difficulty: 1, type: .ciHui)
            XCTAssertNotNil(gameData.phrases.next(), "Game data does not contain phrases")
            XCTAssertEqual(gameData.phrases.next(count: 5).count, 5, "Incorrect amount of phrases")
        }
    }

}
