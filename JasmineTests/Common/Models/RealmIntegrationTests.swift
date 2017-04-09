import XCTest
import RealmSwift
@testable import Jasmine

/// Unlike other tests that involves realm, this uses the real db to ensure it is usuable
class RealmIntegrationTests: XCTestCase {

    var realm: Realm!
    var factory: GameManager!
    var levels: Levels!

    override func setUp() {
        super.setUp()
        do {
            realm = try Realm()
            levels = Levels(realm: realm)
            factory = GameManager(realm: realm)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testRealm_phrases() {
        let gameTypes: [GameType] = [.chengYu, .ciHui]
        gameTypes.forEach { _ in
            let level = levels.original[0]
            let gameData = factory.createGame(fromLevel: level)
            XCTAssertNotNil(gameData.phrases.next(), "Game data does not contain phrases")
            XCTAssertEqual(gameData.phrases.next(count: 5).count, 5, "Incorrect amount of phrases")
        }
    }

}
