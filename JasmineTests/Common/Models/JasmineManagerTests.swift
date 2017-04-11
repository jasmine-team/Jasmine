import XCTest
import RealmSwift
@testable import Jasmine

class JasmineManagerTests: RealmTestCase {

    var gameCenter: GameCenterReporter!

    override func setUp() {
        super.setUp()
        gameCenter = GameCenter(realm: realm)
    }

    func testLevelResultsListener() {
        let phrases = Phrases(List(defaultCiHui))
        var gameData = GameData(name: "Tests", phrases: phrases, difficulty: 1)
        gameData.gameStatus = .endedWithLost
        
        gameCenter.notifier = { changes in
            switch changes {
            case .initial:
                print("IS WORKING")
                return
            case .update(_, _, let insertions, _):
                // results will only ever be inserted, not updated or deleted (unless user reset)
                insertions.forEach { tester in
                    print(tester)
                }
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                assertionFailure("\(error)")
            }
        }
        
        save(LevelResult(level: Level(), gameData: gameData))
        gameData.res
    }

}
