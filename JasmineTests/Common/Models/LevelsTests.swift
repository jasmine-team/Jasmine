import XCTest
import RealmSwift
@testable import Jasmine

class LevelsTests: RealmTestCase {

    let listOfLevels = [
        Level(value: ["isReadOnly": true]),
        Level(value: ["isReadOnly": false]),
        Level(value: ["isReadOnly": false]),
    ]
    var levels: Levels!

    override func setUp() {
        super.setUp()
        listOfLevels.forEach(save)
        levels = Levels(realm: realm)
    }

    func testLevels_original() {
        XCTAssertEqual(levels.original, Array(listOfLevels.prefix(1)), "original does not return read only levels")
    }

    func testLevels_custom() {
        XCTAssertEqual(levels.custom, Array(listOfLevels.suffix(2)), "custom does not return all non read levels")
    }

    func testAddLevel() {
        let name = "test"
        let gameType: GameType = .ciHui
        let gameMode: GameMode = .sliding
        save(Phrase(value: ["rawChinese": "隨意"]))
        let phrases = Phrases(List(realm.objects(Phrase.self)))
        print(phrases.toArray())

        XCTAssertNoThrow(try levels.addCustomLevel(
            name: name,
            gameType: gameType,
            gameMode: gameMode,
            phrases: phrases
        ), "Failed to add level")

        guard let latestLevel = levels.custom.last else {
            XCTFail("Unable to retrieve level")
            return
        }
        XCTAssertEqual(latestLevel.name, name, "Name not persisted")
        XCTAssertEqual(latestLevel.gameType, gameType, "Game type not persisted")
        XCTAssertEqual(latestLevel.gameMode, gameMode, "Game mode not persisted")
        XCTAssertEqual(latestLevel.phrases.toArray(), phrases.toArray(), "Phrases not persisted")
    }

    func testDeleteLevel() {
        XCTAssertEqual(levels.custom, listOfLevels, "Levels are not instantiated")
        XCTAssertNoThrow(try levels.deleteLevel(listOfLevels[1]), "Failed to delete level")
        XCTAssertEqual(levels.custom, Array(listOfLevels.suffix(1)), "custom level not deleted from levels")
    }

    func testResetAll() {
        XCTAssertEqual(levels.custom, listOfLevels, "Levels are not instantiated")
        XCTAssertNoThrow(try levels.resetAll(), "Failed to delete all custom levels")
        XCTAssertTrue(levels.custom.isEmpty, "All custom levels are not erased")
    }
}
