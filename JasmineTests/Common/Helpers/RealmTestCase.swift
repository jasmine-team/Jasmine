import XCTest
import RealmSwift

class RealmTestCase: XCTestCase {

    var realm: Realm!

    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        do {
            realm = try Realm()
        } catch {
            fatalError("Could not instantiate realm")
        }
    }

}

extension GameDataTests {

    func save(_ object: Object) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            XCTFail("Could not write phrase into realm")
        }
    }

}
