import XCTest
import Foundation
@testable import Jasmine

class BaseSwappingViewModelTests: XCTestCase {
    func testInit() {
        guard let gameData = try? GameDataFactory().createGame(difficulty: 1, type: .chengYu) else {
            XCTFail("Realm errors")
            return
        }

        let viewModel = BaseSwappingViewModel(time: 3, gameData: gameData,
                                              tiles: ["a", "b"], rows: 1, columns: 2)

        XCTAssertNil(viewModel.delegate,
                     "ViewModel delegate on init is not nil")
        XCTAssertEqual(0, viewModel.currentScore,
                       "ViewModel currentScore on init is not zero")
        XCTAssertEqual(1, viewModel.numRows,
                       "ViewModel rows on init is not correct")
        XCTAssertEqual(2, viewModel.numColumns,
                       "ViewModel columns on init is not correct")
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
        XCTAssert(["a", "b"].contains { $0 == gridData[Coordinate(row: 0, col: 0)] },
                  "Swapping Data is not correct")
        XCTAssert(["a", "b"].contains { $0 == gridData[Coordinate(row: 0, col: 1)] },
                  "Swapping Data is not correct")
    }

    func testStartGame() {
        guard let gameData = try? GameDataFactory().createGame(difficulty: 1, type: .chengYu) else {
            XCTFail("Realm errors")
            return
        }

        let rows = 1
        let columns = 2
        let time: TimeInterval = 3

        let viewModel = BaseSwappingViewModel(time: time, gameData: gameData, tiles: ["a", "b"],
                                             rows: rows, columns: columns)
        let delegate = SwappingGameViewControllerDelegateMock()
        viewModel.delegate = delegate
        viewModel.startGame()

        XCTAssertEqual(GameStatus.inProgress, viewModel.gameStatus,
                       "ViewModel game status when the game runs is not inProgress")
        XCTAssertEqual(time, delegate.totalTime,
                       "Delegate totalTime is not correct")
        XCTAssertEqual(time, delegate.timeRemaining,
                       "Delegate timeRemaining is not correct")

        RunLoop.current.run(until: Date(timeIntervalSinceNow: time + 1))
        XCTAssertEqual(time, delegate.totalTime,
                       "Delegate totalTime is not correct")
        XCTAssertEqualWithAccuracy(0, delegate.timeRemaining, accuracy: time / 10,
                       "Delegate timeRemaining is not correct")
        XCTAssertEqual(GameStatus.endedWithLost, viewModel.gameStatus,
                       "ViewModel game status when time's up is not endedWithLost")
    }

    func testSwapTiles() {
        guard let gameData = try? GameDataFactory().createGame(difficulty: 1, type: .chengYu) else {
            XCTFail("Realm errors")
            return
        }

        let rows = 2
        let columns = 3
        let time: TimeInterval = 3

        let viewModel = BaseSwappingViewModel(time: time, gameData: gameData,
                                             tiles: ["a", "b", "c", "d", "e", "f"],
                                             rows: rows, columns: columns)
        let delegate = SwappingGameViewControllerDelegateMock()
        viewModel.delegate = delegate
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

    func testHasGameWon() {
        guard let gameData = try? GameDataFactory().createGame(difficulty: 1, type: .chengYu) else {
            XCTFail("Realm errors")
            return
        }

        let viewModel = BaseSwappingViewModel(time: 3, gameData: gameData, tiles: ["a"], rows: 1, columns: 1)

        XCTAssertFalse(viewModel.hasGameWon,
                       "hasGameWon should always return false on BaseSwappingVM")
    }
}
