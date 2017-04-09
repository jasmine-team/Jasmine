import XCTest
import RealmSwift
@testable import Jasmine

class RealmTestCase: XCTestCase {

    var realm: Realm!
    var gameDataFactory: GameManager!

    /// NOTE: This is a computed property for a reason, the Phrases will be saved to the previous realm
    /// instance and inevitably fail tests!
    var defaultCiHui: [Phrase] {
        return [
            Phrase(value: ["rawChinese": "么什", "rawPinyin": "shen me", "english": "test"]),
            Phrase(value: ["rawChinese": "有没", "rawPinyin": "mei you", "english": "test"]),
            Phrase(value: ["rawChinese": "己自", "rawPinyin": "zi ji", "english": "test"]),
            Phrase(value: ["rawChinese": "道知", "rawPinyin": "zhi dao", "english": "test"]),
        ]
    }
    var defaultChengYu: [Phrase] {
        return [
            Phrase(value: ["rawChinese": "容易谈何", "rawPinyin": "tán hé róng yì", "english": "test"]),
            Phrase(value: ["rawChinese": "不通一窍", "rawPinyin": "yī qiào bù tōng", "english": "test"]),
            Phrase(value: ["rawChinese": "惊人一鸣", "rawPinyin": "yī míng jīng rén", "english": "test"]),
            Phrase(value: ["rawChinese": "思议不可", "rawPinyin": "bù kě sī yì", "english": "test"]),
        ]
    }

    override func setUp() {
        super.setUp()
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        do {
            realm = try Realm()
        } catch {
            XCTFail("Could not instantiate realm")
            return
        }
        defaultCiHui.forEach(save)
        defaultChengYu.forEach(save)
        gameDataFactory = GameManager(realm: realm)
    }

    func savePhrase(_ phrase: Phrase) {

    }

    func save(_ object: Object) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch {
            XCTFail("Could not write phrase into realm, \(error.localizedDescription)")
        }
    }

    func createGameData(phrases: [Phrase] = [],
                        difficulty: Int, type: GameType) -> GameData {
        var rawPhrases = phrases
        if phrases.isEmpty {
            rawPhrases = type == .ciHui ? defaultCiHui : defaultChengYu
        }
        let level = Level(value: [
            "rawGameType": type.rawValue,
            "rawPhrases": rawPhrases,
            "difficulty": difficulty,
        ])
        return gameDataFactory.createGame(fromLevel: level)
    }

}
