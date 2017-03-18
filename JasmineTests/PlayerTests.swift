import XCTest
@testable import Jasmine

class PlayerTests: RealmTestCase {

    var player: Player!

    override func setUp() {
        super.setUp()
        player = Player()
    }

    func testPlayer_initialization() {
        XCTAssertEqual(player.totalScore, 0, "totalScore should be zero at start")
        XCTAssertEqual(player.totalPlayCount, 0, "totalPlayCount should be zero at start")

        XCTAssertEqual(player.flappyScore, 0, "flappyScore should be zero at start")
        XCTAssertEqual(player.tetrisScore, 0, "tetrisScore should be zero at start")
        XCTAssertEqual(player.gridScore, 0, "gridScore should be zero at start")

        XCTAssertEqual(player.flappyPlayCount, 0, "flappyPlayCount should be zero at start")
        XCTAssertEqual(player.tetrisPlayCount, 0, "tetrisPlayCount should be zero at start")
        XCTAssertEqual(player.gridPlayCount, 0, "gridPlayCount should be zero at start")
    }

    func testPlayer_flappyScore_increment() {
        let noIncrement = 0
        player.flappyScore += noIncrement
        XCTAssertEqual(player.totalScore, noIncrement, "Total score is not incremented")
        let incrementAmount = 5
        player.flappyScore += incrementAmount
        XCTAssertEqual(player.totalScore, incrementAmount, "Total score is incremented")
    }

    func testPlayer_gridScore_increment() {
        let noIncrement = 0
        player.gridScore += noIncrement
        XCTAssertEqual(player.totalScore, noIncrement, "Total score is not incremented")
        let incrementAmount = 5
        player.gridScore += incrementAmount
        XCTAssertEqual(player.totalScore, incrementAmount, "Total score is incremented")
    }

    func testPlayer_tetrisScore_increment() {
        let noIncrement = 0
        player.tetrisScore += noIncrement
        XCTAssertEqual(player.totalScore, noIncrement, "Total score is not incremented")
        let incrementAmount = 5
        player.tetrisScore += incrementAmount
        XCTAssertEqual(player.totalScore, incrementAmount, "Total score is incremented")
    }

    func testPlayer_flappyPlayCount_increment() {
        let noIncrement = 0
        XCTAssertEqual(player.flappyPlayCount, noIncrement, "Flappy play count is not incremented")
        XCTAssertEqual(player.totalPlayCount, noIncrement, "Total play count is not incremented")
        let incrementAmount = 1
        player.incrementFlappyPlayCount()
        XCTAssertEqual(player.flappyPlayCount, incrementAmount, "Flappy play count is incremented")
        XCTAssertEqual(player.totalPlayCount, incrementAmount, "Total play count is incremented")
    }

    func testPlayer_gridPlayCount_increment() {
        let noIncrement = 0
        XCTAssertEqual(player.gridPlayCount, noIncrement, "Grid play count is not incremented")
        XCTAssertEqual(player.totalPlayCount, noIncrement, "Total play count is not incremented")
        let incrementAmount = 1
        player.incrementGridPlayCount()
        XCTAssertEqual(player.gridPlayCount, incrementAmount, "Grid play count is incremented")
        XCTAssertEqual(player.totalPlayCount, incrementAmount, "Total play count is incremented")
    }

    func testPlayer_tetrisPlayCount_increment() {
        let noIncrement = 0
        XCTAssertEqual(player.tetrisPlayCount, noIncrement, "Tetris play count is not incremented")
        XCTAssertEqual(player.totalPlayCount, noIncrement, "Total play count is not incremented")
        let incrementAmount = 1
        player.incrementTetrisPlayCount()
        XCTAssertEqual(player.tetrisPlayCount, incrementAmount, "Tetris play count is incremented")
        XCTAssertEqual(player.totalPlayCount, incrementAmount, "Total play count is incremented")
    }
}
