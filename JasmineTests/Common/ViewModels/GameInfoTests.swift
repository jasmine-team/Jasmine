import XCTest
@testable import Jasmine

class GameInfoTests: XCTest {
    func testConstructGameInfo() {
        let level1 = Level(value: ["name": "test1", "isReadOnly": true])
        let level2 = Level(value: ["name": "test1", "isReadOnly": false])

        XCTAssertEqual(GameInfo(levelName: level1.name,
                                gameType: level1.gameType, gameMode: level1.gameMode, isEditable: false),
                       GameInfo.from(level: level1))
        XCTAssertEqual(GameInfo(levelName: level2.name,
                                gameType: level2.gameType, gameMode: level2.gameMode, isEditable: true),
                       GameInfo.from(level: level2))
    }

    func testEquatable() {
        XCTAssertEqual(GameInfo(levelName: "b", gameType: .ciHui, gameMode: .sliding, isEditable: true),
                       GameInfo(levelName: "b", gameType: .ciHui, gameMode: .sliding, isEditable: true))
        XCTAssertNotEqual(GameInfo(levelName: "b", gameType: .ciHui, gameMode: .sliding, isEditable: true),
                          GameInfo(levelName: "b", gameType: .ciHui, gameMode: .swapping, isEditable: true))
        XCTAssertNotEqual(GameInfo(levelName: "b", gameType: .ciHui, gameMode: .sliding, isEditable: true),
                          GameInfo(levelName: "b", gameType: .chengYu, gameMode: .sliding, isEditable: true))
        XCTAssertNotEqual(GameInfo(levelName: "b", gameType: .ciHui, gameMode: .sliding, isEditable: true),
                          GameInfo(levelName: "c", gameType: .ciHui, gameMode: .sliding, isEditable: true))
        XCTAssertNotEqual(GameInfo(levelName: "b", gameType: .ciHui, gameMode: .sliding, isEditable: true),
                          GameInfo(levelName: "b", gameType: .ciHui, gameMode: .sliding, isEditable: false))
    }
}
