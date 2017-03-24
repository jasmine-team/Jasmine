import XCTest
import Foundation
@testable import Jasmine

class BaseGridViewModelTests: XCTestCase {
    func testInit() {
        let viewModel = BaseGridViewModel(time: 3, tiles: ["a", "b"],
                                          possibleAnswers: [["a", "b"]],
                                          rows: 1, columns: 2)

        let possibilities = [[Coordinate(row: 0, col: 0): "a", Coordinate(row: 0, col: 1): "b"],
                             [Coordinate(row: 0, col: 0): "b", Coordinate(row: 0, col: 1): "a"]]

        XCTAssert(possibilities.contains { $0 == viewModel.gridData },
                  "ViewModel gridData on init is not empty")
        XCTAssertNil(viewModel.delegate,
                     "ViewModel delegate on init is not nil")
        XCTAssertEqual(0, viewModel.currentScore,
                       "ViewModel currentScore on init is not zero")
        XCTAssertEqual(1, viewModel.rows,
                       "ViewModel rows on init is not correct")
        XCTAssertEqual(2, viewModel.columns,
                       "ViewModel columns on init is not correct")
        XCTAssertEqual(0, viewModel.currentScore,
                       "ViewModel currentScore on init is not correct")
        XCTAssertEqual(GameStatus.notStarted, viewModel.gameStatus,
                       "ViewModel gameStatus on init is not correct")
        XCTAssertEqual("Grid Game", viewModel.gameTitle,
                       "ViewModel gameTitle on init is not correct")
        XCTAssertEqual("Match the Chinese characters with their Pinyins by putting them in one row.",
                       viewModel.gameInstruction,
                       "ViewModel gameInstruction on init is not correct")
    }

    func testStartGame() {
        let rows = 1
        let columns = 2
        let time: TimeInterval = 3

        let viewModel = BaseGridViewModel(time: time, tiles: ["a", "b"],
                                          possibleAnswers: [["a", "b"]],
                                          rows: rows, columns: columns)
        let delegate = GridGameViewControllerDelegateMock()
        viewModel.delegate = delegate
        viewModel.startGame()

        XCTAssertEqual(GameStatus.inProgress, viewModel.gameStatus,
                       "ViewModel game status when the game runs is not inProgress")
        XCTAssertEqual(rows * columns, viewModel.gridData.count,
                       "ViewModel gridData is not correctly populated")
        for row in 0..<rows {
            for col in 0..<columns {
                XCTAssertNotNil(viewModel.gridData[Coordinate(row: row, col: col)],
                                "ViewModel gridData is not correctly populated")
            }
        }
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
        let rows = 2
        let columns = 3
        let time: TimeInterval = 3

        let viewModel = BaseGridViewModel(time: time, tiles: ["a", "b", "c", "d", "e", "f"],
                                          possibleAnswers: [["a", "b", "c"], ["d", "e", "f"]],
                                          rows: rows, columns: columns)
        let delegate = GridGameViewControllerDelegateMock()
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

    func testSwapTilesFail() {
        let rows = 1
        let columns = 2
        let time: TimeInterval = 3

        let viewModel = BaseGridViewModel(time: time, tiles: ["a", "b"],
                                          possibleAnswers: [["a", "b"]],
                                          rows: rows, columns: columns)
        let delegate = GridGameViewControllerDelegateMock()
        viewModel.delegate = delegate
        viewModel.startGame()

        XCTAssertFalse(viewModel.swapTiles(Coordinate(row: 5, col: 0), and: Coordinate(row: 0, col: 7)),
                       "Swapping tiles with invalid coordinates are allowed")
    }

    func testGameWon() {
        let rows = 1
        let columns = 2
        let time: TimeInterval = 3

        var viewModel = BaseGridViewModel(time: time, tiles: ["a", "b"],
                                          possibleAnswers: [["a", "b"]],
                                          rows: rows, columns: columns)
        var gridData: [Coordinate: String] = viewModel.gridData

        while gridData != [Coordinate(row: 0, col: 0): "b", Coordinate(row: 0, col: 1): "a"] {
            viewModel = BaseGridViewModel(time: time, tiles: ["a", "b"],
                                          possibleAnswers: [["a", "b"]],
                                          rows: rows, columns: columns)
            gridData = viewModel.gridData
        }

        viewModel.startGame()
        viewModel.swapTiles(Coordinate(row: 0, col: 0), and: Coordinate(row: 0, col: 1))
        XCTAssertEqual(GameStatus.endedWithWon, viewModel.gameStatus,
                       "ViewModel game status when grid's done is not endedWithWon")
    }
}
