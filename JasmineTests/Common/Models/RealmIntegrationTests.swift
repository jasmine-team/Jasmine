import XCTest
import RealmSwift
@testable import Jasmine

/// Unlike other tests that involves realm, this uses the real db to ensure it is usuable
class RealmIntegrationTests: XCTestCase {

    var realm: Realm!
    var factory: GameManager!
    var levels: Levels!

    override func setUp() {
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 1, // Set the new schema version.
            // We haven't migrated anything, so oldSchemaVersion = 0.
            // Realm will automatically detect new properties and removed properties
            // by accessing the oldSchemaVersion property.
            migrationBlock: { _, oldSchemaVersion in _ = oldSchemaVersion }
        )
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
            XCTAssertNotNil(gameData.phrases.randomGenerator.next(), "Game data does not contain phrases")
            let phrases = gameData.phrases.randomGenerator.next(count: 5)
            XCTAssertEqual(phrases.count, 5, "Incorrect amount of phrases")
        }
    }

}
