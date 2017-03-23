import XCTest
import Foundation
@testable import Jasmine

class GridViewModelTests: XCTestCase {
    func testInit() {
        let viewModel = GridViewModel()

        XCTAssertEqual([:], viewModel.gridData,
                       "ViewModel gridData on init is not empty")
        XCTAssertNil(viewModel.delegate,
                     "ViewModel delegate on init is not nil")
        XCTAssertEqual(0, viewModel.currentScore,
                       "ViewModel currentScore on init is not zero")
        XCTAssertEqual(Constants.Grid.time, viewModel.timer.totalTimeAllowed,
                       "ViewModel timer on init is not correct")
        XCTAssertEqual(GameStatus.notStarted, viewModel.gameStatus,
                       "ViewModel gameStatus on init is not correct")
        XCTAssertEqual("Grid Game", viewModel.gameTitle,
                       "ViewModel gameTitle on init is not correct")
        XCTAssertEqual("Match the Chinese characters with their Pinyins by putting them in one row.",
                       viewModel.gameInstruction,
                       "ViewModel gameInstruction on init is not correct")
    }

    func testStartGame() {
        let viewModel = GridViewModel()
        let delegate = GridGameViewControllerDelegateMock()
        viewModel.delegate = delegate
        viewModel.startGame()

        XCTAssertEqual(GameStatus.inProgress, viewModel.gameStatus,
                       "ViewModel game status when the game runs is not inProgress")
        XCTAssertEqual(Constants.Grid.rows * Constants.Grid.columns, viewModel.gridData.count,
                       "ViewModel gridData is not correctly populated")
        for row in 0..<Constants.Grid.rows {
            for col in 0..<Constants.Grid.columns {
                XCTAssertNotNil(viewModel.gridData[Coordinate(row: row, col: col)],
                                "ViewModel gridData is not correctly populated")
            }
        }
        XCTAssert(delegate.allTilesRedisplayed,
                  "Delegate redisplayAllTiles is not called")
        XCTAssertEqual(Constants.Grid.time, delegate.totalTime,
                       "Delegate totalTime is not correct")
        XCTAssertEqual(Constants.Grid.time, delegate.timeRemaining,
                       "Delegate timeRemaining is not correct")

        RunLoop.current.run(until: Date(timeIntervalSinceNow: Constants.Grid.time + 1))
        XCTAssertEqual(Constants.Grid.time, delegate.totalTime,
                       "Delegate totalTime is not correct")
        XCTAssertEqualWithAccuracy(0, delegate.timeRemaining, accuracy: Constants.Grid.time / 10,
                       "Delegate timeRemaining is not correct")
        XCTAssertEqual(GameStatus.endedWithLost, viewModel.gameStatus,
                       "ViewModel game status when time's up is not endedWithLost")
    }

    func testSwapTiles() {
        let viewModel = GridViewModel()
        let delegate = GridGameViewControllerDelegateMock()
        viewModel.delegate = delegate
        viewModel.startGame()

        let initialGrid = viewModel.gridData
        XCTAssert(viewModel.swapTiles(Coordinate(row: 0, col: 0), and: Coordinate(row: 1, col: 1)),
                  "Swapping tiles is not possible")

        for row in 0..<Constants.Grid.rows {
            for col in 0..<Constants.Grid.columns {
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
        let viewModel = GridViewModel()
        let delegate = GridGameViewControllerDelegateMock()
        viewModel.delegate = delegate
        viewModel.startGame()

        XCTAssertFalse(viewModel.swapTiles(Coordinate(row: 5, col: 0), and: Coordinate(row: 0, col: 7)),
                       "Swapping tiles with invalid coordinates are allowed")
    }

    // TODO
    // Not sure how to test for winning game. I think my VM is quite tight currently; will refactor
    // when models are ready.
}
