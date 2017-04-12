import XCTest
@testable import Jasmine

class GameInfoTests: XCTest {
    func testConstructGameInfo() {
        let level = Level(value: ["name": "test1", "isReadOnly": true])

        XCTAssertEqual(GameInfo(uuid: level.uuid, levelName: level.name,
                                gameType: level.gameType, gameMode: level.gameMode),
                       GameInfo.constructGameInfo(from: level))
    }

    func testEquatable() {
        XCTAssertEqual(GameInfo(uuid: "a", levelName: "b", gameType: .ciHui, gameMode: .sliding),
                       GameInfo(uuid: "a", levelName: "b", gameType: .ciHui, gameMode: .sliding))
        XCTAssertNotEqual(GameInfo(uuid: "a", levelName: "b", gameType: .ciHui, gameMode: .sliding),
                          GameInfo(uuid: "a", levelName: "b", gameType: .ciHui, gameMode: .swapping))
        XCTAssertNotEqual(GameInfo(uuid: "a", levelName: "b", gameType: .ciHui, gameMode: .sliding),
                          GameInfo(uuid: "a", levelName: "b", gameType: .chengYu, gameMode: .sliding))
        XCTAssertNotEqual(GameInfo(uuid: "a", levelName: "b", gameType: .ciHui, gameMode: .sliding),
                          GameInfo(uuid: "a", levelName: "c", gameType: .ciHui, gameMode: .sliding))
        XCTAssertNotEqual(GameInfo(uuid: "a", levelName: "b", gameType: .ciHui, gameMode: .sliding),
                          GameInfo(uuid: "x", levelName: "b", gameType: .ciHui, gameMode: .sliding))
    }
}
