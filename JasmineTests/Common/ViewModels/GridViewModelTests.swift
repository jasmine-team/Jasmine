import XCTest
@testable import Jasmine

class GridViewModelTests: XCTestCase {
    func testInit() {
        guard let gameDataFactory = try? GameDataFactory() else {
            XCTFail("Realm error")
            return
        }

        let time: TimeInterval = 10
        let gameData = gameDataFactory.createGame(difficulty: 1, type: .ciHui)
        let grid = [["a", "b"], ["c", nil]]
        let textGrid = TextGrid(fromInitialGrid: grid)

        let viewModel = GridViewModel(time: time, gameData: gameData, textGrid: textGrid)

        XCTAssertEqual(0, viewModel.currentScore,
                       "ViewModel currentScore not correct on init")
        XCTAssertEqual(2, viewModel.numRows,
                       "ViewModel numRows not correct on init")
        XCTAssertEqual(2, viewModel.numColumns,
                       "ViewModel numColumns not correct on init")
        XCTAssertEqual(GameStatus.notStarted, viewModel.gameStatus,
                       "ViewModel gameStatus not correct on init")
        XCTAssertEqual([Coordinate(row: 0, col: 0): "a",
                        Coordinate(row: 0, col: 1): "b",
                        Coordinate(row: 1, col: 0): "c"],
                       viewModel.gridData.coordinateDictionary,
                       "ViewModel gridData not correct on init")
        XCTAssertEqual("", viewModel.gameTitle,
                       "ViewModel gameTitle not correct on init")
        XCTAssertEqual("", viewModel.gameInstruction,
                       "ViewModel gameInstruction not correct on init")
        XCTAssertEqual(0, viewModel.score,
                       "ViewModel score not correct on init")
        XCTAssertFalse(viewModel.lineIsCorrect([]),
                       "ViewModel lineIsCorrect not correct on init")
    }

    func testStartGame() {
        guard let gameDataFactory = try? GameDataFactory() else {
            XCTFail("Realm error")
            return
        }

        let time: TimeInterval = 3
        let gameData = gameDataFactory.createGame(difficulty: 1, type: .ciHui)
        let grid = [["a", "b"], ["c", nil]]
        let textGrid = TextGrid(fromInitialGrid: grid)

        let viewModel = GridViewModel(time: time, gameData: gameData, textGrid: textGrid)

        viewModel.startGame()
        RunLoop.current.run(until: Date(timeIntervalSinceNow: time + 1))

        XCTAssertEqualWithAccuracy(0, viewModel.timeRemaining,
                                   accuracy: 0.01, "Time remaining not correct")
        XCTAssertEqual(time, viewModel.totalTimeAllowed, "Total time allowed not correct")
    }

    func testCheckGameWonHasNotWon() {
        guard let gameDataFactory = try? GameDataFactory() else {
            XCTFail("Realm error")
            return
        }

        let time: TimeInterval = 3
        let gameData = gameDataFactory.createGame(difficulty: 1, type: .ciHui)
        let grid = [["a", "b"], ["c", nil]]
        let textGrid = TextGrid(fromInitialGrid: grid)

        let viewModel = GridViewModel(time: time, gameData: gameData, textGrid: textGrid)

        viewModel.checkGameWon()

        XCTAssertNotEqual(GameStatus.endedWithWon, viewModel.gameStatus,
                          "When game is actually not won, game status changed wrongly to endedWithWon")
        XCTAssertEqual(0, viewModel.currentScore,
                       "When game is actually not won, score is incremented")
    }

    func testCheckGameWonWithSameRow() {
        guard let gameDataFactory = try? GameDataFactory() else {
            XCTFail("Realm error")
            return
        }

        let time: TimeInterval = 3
        let gameData = gameDataFactory.createGame(difficulty: 1, type: .ciHui)
        let grid = [["a", "b"], ["c", nil]]
        let textGrid = TextGrid(fromInitialGrid: grid)

        let viewModel = GridViewModelSameRowMock(time: time, gameData: gameData, textGrid: textGrid)
        viewModel.startGame()

        viewModel.checkGameWon()

        XCTAssertEqual(GameStatus.endedWithWon, viewModel.gameStatus,
                       "Game should be able to win by all rows correct, and game status should be updated")
        XCTAssertEqual(viewModel.score, viewModel.currentScore,
                       "Game should be able to win by all rows correct, and score should be updated")
    }

    func testCheckGameWonWithSameColumn() {
        guard let gameDataFactory = try? GameDataFactory() else {
            XCTFail("Realm error")
            return
        }

        let time: TimeInterval = 3
        let gameData = gameDataFactory.createGame(difficulty: 1, type: .ciHui)
        let grid = [["a", "b"], ["c", nil]]
        let textGrid = TextGrid(fromInitialGrid: grid)

        let viewModel = GridViewModelSameColumnMock(time: time, gameData: gameData, textGrid: textGrid)
        viewModel.startGame()

        viewModel.checkGameWon()

        XCTAssertEqual(GameStatus.endedWithWon, viewModel.gameStatus,
                       "Game should be able to win by all columns correct, and game status should be updated")
        XCTAssertEqual(viewModel.score, viewModel.currentScore,
                       "Game should be able to win by all columns correct, and score should be updated")
    }
}
