import XCTest
import RealmSwift
@testable import Jasmine

class RealmTestCase: XCTestCase {

    var realm: Realm!
    var gameDataFactory: GameManager!
    
    static let defaultPhrases = [
        Phrase(value: ["rawChinese": "什么", "rawPinYin": "shen me", "english": "test"]),
        Phrase(value: ["rawChinese": "没有", "rawPinYin": "mei you", "english": "test"]),
        Phrase(value: ["rawChinese": "自己", "rawPinYin": "zi ji", "english": "test"]),
        Phrase(value: ["rawChinese": "知道", "rawPinYin": "zhi dao", "english": "test"]),
        Phrase(value: ["rawChinese": "谈何容易", "rawPinYin": "tán hé róng yì", "english": "test"]),
        Phrase(value: ["rawChinese": "一窍不通", "rawPinYin": "yī qiào bù tōng", "english": "test"]),
        Phrase(value: ["rawChinese": "一鸣惊人", "rawPinYin": "yī míng jīng rén", "english": "test"]),
        Phrase(value: ["rawChinese": "不可思议", "rawPinYin": "bù kě sī yì", "english": "test"]),
    ]

    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        do {
            realm = try Realm()
        } catch {
            fatalError("Could not instantiate realm")
        }

        gameDataFactory = GameManager(realm: realm)
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

    func createGameData(phrases: [Phrase] = RealmTestCase.defaultPhrases, 
                        difficulty: Int, type: GameType) -> GameData {
        phrases.forEach(save)
        let level = Level(value: [
            "rawGameType": type.rawValue,
            "difficulty": difficulty
        ])
        return gameDataFactory.createGame(fromLevel: level)
    }
}
