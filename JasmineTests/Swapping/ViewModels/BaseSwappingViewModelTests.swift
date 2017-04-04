import XCTest
import Foundation
@testable import Jasmine

class BaseSwappingViewModelTests: XCTestCase {

    var gameData: GameData!
    let rows = 2
    let columns = 2
    let time: TimeInterval = 3
    var viewModel: BaseSwappingViewModel!

    override func setUp() {
        guard let gameData = try? GameDataFactory().createGame(difficulty: 1, type: .chengYu) else {
            XCTFail("Realm errors")
            return
        }
        self.gameData = gameData

        viewModel = BaseSwappingViewModel(time: time, gameData: gameData,
                                          tiles: ["a", "b", "c", "d"], rows: rows, columns: columns)
    }

    func testInit() {
        XCTAssertNil(viewModel.gameStatusDelegate,
                     "ViewModel delegate on init is not nil")
        XCTAssertNil(viewModel.timeDelegate,
                     "ViewModel delegate on init is not nil")
        XCTAssertNil(viewModel.scoreDelegate,
                     "ViewModel delegate on init is not nil")

        XCTAssertEqual(0, viewModel.currentScore,
                       "ViewModel currentScore on init is not zero")
        XCTAssertEqual(3, viewModel.timeRemaining,
                       "ViewModel timeRemaining on init is not correct")
        XCTAssertEqual(3, viewModel.totalTimeAllowed,
                       "ViewModel timeRemaining on init is not correct")
        XCTAssertEqual(GameStatus.notStarted, viewModel.gameStatus,
                       "ViewModel gameStatus on init is not correct")
        XCTAssertEqual("", viewModel.gameTitle,
                       "ViewModel gameTitle on init is not correct")
        XCTAssertEqual("", viewModel.gameInstruction,
                       "ViewModel gameInstruction on init is not correct")

        let gridData = viewModel.gridData
        for (row, col) in [(0, 0), (0, 1), (1, 0), (1, 1)] {
            let coord = Coordinate(row: row, col: col)
            XCTAssert(["a", "b", "c", "d"].contains { $0 == gridData[coord] },
                      "Swapping Data is not correct")
        }
    }

    func testStartGame() {
        let timeDelegate = TimeUpdateDelegateMock()
        let gameStatusDelegate = GameStatusUpdateDelegateMock()
        viewModel.timeDelegate = timeDelegate
        viewModel.gameStatusDelegate = gameStatusDelegate

        viewModel.startGame()
        XCTAssertEqual(GameStatus.inProgress, viewModel.gameStatus,
                       "ViewModel game status when the game runs is not inProgress")
        XCTAssertEqual(1, timeDelegate.timeUpdated,
                       "Delegate time not updated once")
        XCTAssertEqual(1, gameStatusDelegate.gameStatusUpdated,
                       "Delegate game status not updated once -> inProgress")

        RunLoop.current.run(until: Date(timeIntervalSinceNow: time + 1))
        XCTAssertEqual(3 * Int(1 / Constants.Game.timeInterval),
                       timeDelegate.timeUpdated - 1,
                       "Delegate time not updated time * timerInterval times")
        XCTAssertEqual(GameStatus.endedWithLost, viewModel.gameStatus,
                       "ViewModel game status when time's up is not endedWithLost")
        XCTAssertEqual(2, gameStatusDelegate.gameStatusUpdated,
                       "Delegate game status not updated once -> inProgress -> endedWithLost")
    }

    func testSwapTiles() {
        viewModel.startGame()

        let initialGrid = viewModel.gridData
        XCTAssert(viewModel.swapTiles(Coordinate(row: 0, col: 0), and: Coordinate(row: 1, col: 1)),
                  "Swapping tiles is not possible")

        for row in 0..<rows {
            for col in 0..<columns {
                if (row, col) == (0, 0) {
                    XCTAssertEqual(initialGrid[Coordinate(row: 1, col: 1)],
                                   viewModel.gridData[Coordinate(row: 0, col: 0)],
                                   "Tiles are not swapped properly")
                } else if (row, col) == (1, 1) {
                    XCTAssertEqual(initialGrid[Coordinate(row: 0, col: 0)],
                                   viewModel.gridData[Coordinate(row: 1, col: 1)],
                                   "Tiles are not swapped properly")
                } else {
                    XCTAssertEqual(initialGrid[Coordinate(row: row, col: col)],
                                   viewModel.gridData[Coordinate(row: row, col: col)],
                                   "Tiles that are not swapped have changed")
                }
            }
        }
    }

    func testScore() {
        XCTAssertEqual(2_300, viewModel.score)
        viewModel.swapTiles(Coordinate(row: 0, col: 0), and: Coordinate(row: 0, col: 1))
        XCTAssertEqual(2_250, viewModel.score)

        viewModel.startGame()
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        XCTAssert(abs(2_150 - viewModel.score) <= 5)
    }
}
