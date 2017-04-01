import XCTest
import Foundation
@testable import Jasmine

class GridViewModelTests: XCTestCase {
    func testInit() {
        let viewModel = GridViewModel()

        XCTAssertNil(viewModel.delegate,
                     "ViewModel delegate on init is not nil")
        XCTAssertEqual(0, viewModel.currentScore,
                       "ViewModel currentScore on init is not zero")
        XCTAssertEqual(Constants.Game.Grid.time, viewModel.timer.totalTimeAllowed,
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
        for row in 0..<Constants.Game.Grid.rows {
            for col in 0..<Constants.Game.Grid.columns {
                XCTAssertNotNil(viewModel.gridData[Coordinate(row: row, col: col)],
                                "ViewModel gridData is not correctly populated")
            }
        }
        XCTAssertEqual(Constants.Game.Grid.time, delegate.totalTime,
                       "Delegate totalTime is not correct")
        XCTAssertEqual(Constants.Game.Grid.time, delegate.timeRemaining,
                       "Delegate timeRemaining is not correct")

        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        XCTAssertEqual(Constants.Game.Grid.time, delegate.totalTime,
                       "Delegate totalTime is not correct")
        XCTAssertEqualWithAccuracy(delegate.timeRemaining, delegate.totalTime - 1,
                                   accuracy: Constants.Game.Grid.time / 10,
                                   "Delegate timeRemaining is not correct")
        XCTAssertEqual(viewModel.gameStatus, GameStatus.inProgress,
                       "ViewModel game status is not in progress")
    }

    func testSwapTiles() {
        let viewModel = GridViewModel()
        let delegate = GridGameViewControllerDelegateMock()
        viewModel.delegate = delegate
        viewModel.startGame()

        let initialGrid = viewModel.gridData
        XCTAssert(viewModel.swapTiles(Coordinate(row: 0, col: 0), and: Coordinate(row: 1, col: 1)),
                  "Swapping tiles is not possible")

        for row in 0..<Constants.Game.Grid.rows {
            for col in 0..<Constants.Game.Grid.columns {
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

    // TODO
    // Not sure how to test for winning game. I think my VM is quite tight currently; will refactor
    // when models are ready.
}
