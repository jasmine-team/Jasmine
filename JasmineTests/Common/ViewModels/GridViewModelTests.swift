import XCTest
@testable import Jasmine

class GridViewModelTests: XCTestCase {
    var gameData: GameData!

    override func setUp() {
        guard let gameDataFactory = try? GameDataFactory() else {
            XCTFail("Realm error")
            return
        }
        gameData = gameDataFactory.createGame(difficulty: 1, type: .ciHui)
    }

    func testInit() {
        let time: TimeInterval = 10
        let grid = [["a", "b"], ["c", nil]]
        let textGrid = TextGrid(fromInitialGrid: grid)

        let viewModel = GridViewModel(time: time, gameData: gameData, textGrid: textGrid)

        XCTAssertEqual(0, viewModel.currentScore,
                       "ViewModel currentScore not correct on init")
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
    }

    func testStartGame() {
        let time: TimeInterval = 3
        let grid = [["a", "b"], ["c", nil]]
        let textGrid = TextGrid(fromInitialGrid: grid)

        let viewModel = GridViewModel(time: time, gameData: gameData, textGrid: textGrid)

        viewModel.startGame()
        RunLoop.current.run(until: Date(timeIntervalSinceNow: time + 1))

        XCTAssertEqualWithAccuracy(0, viewModel.timeRemaining,
                                   accuracy: 0.01, "Time remaining not correct")
        XCTAssertEqual(time, viewModel.totalTimeAllowed, "Total time allowed not correct")
    }
}
