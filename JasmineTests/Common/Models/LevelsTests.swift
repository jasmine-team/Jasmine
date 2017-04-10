import XCTest
import RealmSwift
@testable import Jasmine

class LevelsTests: RealmTestCase {

    let originalLevels = [
        Level(value: ["name": "test1", "isReadOnly": true]),
    ]
    let customLevels = [
        Level(value: ["name": "test2", "isReadOnly": false]),
        Level(value: ["name": "test3", "isReadOnly": false]),
    ]
    var levels: Levels!

    override func setUp() {
        super.setUp()
        originalLevels.forEach(save)
        customLevels.forEach(save)
        levels = Levels(realm: realm)
    }

    func testLevels_original() {
        XCTAssertEqual(levels.original, originalLevels, "original does not return read only levels")
    }

    func testLevels_custom() {
        XCTAssertEqual(levels.custom, customLevels, "custom does not return all non read levels")
    }

    func testAddLevel() {
        let name = "test"
        let gameType: GameType = .ciHui
        let gameMode: GameMode = .sliding
        let phrases = [Phrase(value: ["rawChinese": "x y"])]

        guard (try? levels.addCustomLevel(
            name: name,
            gameType: gameType,
            gameMode: gameMode,
            phrases: phrases
        )) != nil else {
            XCTFail("Failed to add level")
            return
        }

        guard let latestLevel = levels.custom.last else {
            XCTFail("Unable to retrieve level")
            return
        }
        XCTAssertEqual(latestLevel.name, name, "Name not persisted")
        XCTAssertEqual(latestLevel.gameType, gameType, "Game type not persisted")
        XCTAssertEqual(latestLevel.gameMode, gameMode, "Game mode not persisted")
        XCTAssertEqual(latestLevel.phrases.toArray(), phrases, "Phrases not persisted")
    }

    func testDeleteLevel() {
        XCTAssertEqual(levels.custom, customLevels, "Levels are not instantiated")
        guard (try? levels.deleteLevel(customLevels[1])) != nil else {
            XCTFail("Failed to delete level")
            return
        }
        XCTAssertEqual(levels.custom, [customLevels[0]], "custom level not deleted from levels")
    }

    func testResetAll() {
        XCTAssertEqual(levels.custom, customLevels, "Levels are not instantiated")
        guard (try? levels.resetAll()) != nil else {
            XCTFail("Failed to delete all custom levels")
            return
        }
        XCTAssertTrue(levels.custom.isEmpty, "All custom levels are not erased")
    }
}
