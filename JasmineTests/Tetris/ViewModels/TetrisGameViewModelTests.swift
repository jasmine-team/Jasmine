import XCTest
@testable import Jasmine
import RealmSwift

class TetrisGameViewModelTests: RealmTestCase {

    var gameData: GameData! // Initialize in setUp

    override func setUp() {
        super.setUp()
        let phrases = [Phrase(value: ["chinese": "脱颖而出"])]
        gameData = createGameData(phrases: phrases, difficulty: 1, type: .chengYu)
    }

    func testInit() {
        let viewModel = TetrisGameViewModel(gameData: gameData)

        XCTAssertNil(viewModel.delegate,
                     "ViewModel delegate on init is not nil")
        XCTAssertEqual(0, viewModel.currentScore,
                       "ViewModel currentScore on init is not zero")
        XCTAssertEqual(Constants.Game.Tetris.totalTime, viewModel.timer.totalTimeAllowed,
                       "ViewModel timer on init is not correct")
        XCTAssertEqual(GameStatus.notStarted, viewModel.gameStatus,
                       "ViewModel gameStatus on init is not correct")
        XCTAssertEqual(Constants.Game.Tetris.gameTitle, viewModel.gameTitle,
                       "ViewModel gameTitle on init is not correct")
        XCTAssertEqual(Constants.Game.Tetris.gameInstruction, viewModel.gameInstruction,
                       "ViewModel gameInstruction on init is not correct")
        XCTAssertEqual(Constants.Game.Tetris.upcomingTilesCount, viewModel.upcomingTiles.count,
                       "ViewModel upcomingTiles count on init is not correct")
    }

    func testStartGame() {
        let viewModel = TetrisGameViewModel(gameData: gameData)
        let delegate = TetrisGameViewControllerDelegateMock()
        viewModel.delegate = delegate
        viewModel.startGame()

        XCTAssertEqual(GameStatus.inProgress, viewModel.gameStatus,
                       "ViewModel game status when the game runs is not inProgress")

        RunLoop.current.run(until: Date(timeIntervalSinceNow: Constants.Game.Tetris.totalTime + 1))
        XCTAssertEqual(Constants.Game.Tetris.totalTime, delegate.totalTime,
                       "Delegate totalTime is not correct")
        if let timeRemaining = delegate.timeRemaining {
            XCTAssertEqualWithAccuracy(0, timeRemaining, accuracy: Constants.Game.Tetris.totalTime / 10,
                                       "Delegate timeRemaining is not correct")
        } else {
            XCTAssert(false, "Delegate time remaining is not set")
        }
        XCTAssertEqual(GameStatus.endedWithLost, viewModel.gameStatus,
                       "ViewModel game status when time's up is not endedWithLost")
    }

    func testSwapTiles() {
        let viewModel = TetrisGameViewModel(gameData: gameData)
        let delegate = TetrisGameViewControllerDelegateMock()
        viewModel.delegate = delegate
        viewModel.startGame()

        _ = viewModel.dropNextTile()
        viewModel.swapFallingTile(withUpcomingAt: 1)
        XCTAssert(delegate.upcomingTilesRedisplayed, "Delegate upcoming tile is not redisplayed")
    }

    func testCanShiftFallingTile() {
        let viewModel = TetrisGameViewModel(gameData: gameData)
        XCTAssertTrue(viewModel.canShiftFallingTile(to: Coordinate(row: 0, col: 0)),
                      "canShiftFallingTile wrongly returned false")

    }
}
