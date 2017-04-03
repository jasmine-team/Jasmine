import XCTest
import RealmSwift
@testable import Jasmine

class RealmTestCase: XCTestCase {

    var realm: Realm!
    var gameDataFactory: GameDataFactory!

    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        do {
            realm = try Realm()
        } catch {
            fatalError("Could not instantiate realm")
        }

        gameDataFactory = GameDataFactory(realm: realm)
    }

    func save(_ object: Object) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            XCTFail("Could not write phrase into realm")
        }
    }

    func createGameData(phrases: [Phrase], difficulty: Int, type: GameType) -> GameData {
        phrases.forEach(save)
        return gameDataFactory.createGame(difficulty: difficulty, type: type)
    }
}
