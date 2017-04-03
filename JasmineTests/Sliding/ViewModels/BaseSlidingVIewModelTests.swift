import XCTest
import Foundation
@testable import Jasmine

class BaseSlidingViewModelTests: XCTestCase {
    func testInit() {
        guard let gameData = try? GameDataFactory().createGame(difficulty: 1, type: .chengYu) else {
            XCTFail("Realm errors")
            return
        }

        let viewModel = BaseSlidingViewModel(time: 3, gameData: gameData, tiles: ["a", "b"], rows: 1, columns: 2)

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
                  "Grid Data is not correct")
        XCTAssert(["a", "b"].contains { $0 == gridData[Coordinate(row: 0, col: 1)] },
                  "Grid Data is not correct")
    }

    func testStartGame() {
        guard let gameData = try? GameDataFactory().createGame(difficulty: 1, type: .chengYu) else {
            XCTFail("Realm errors")
            return
        }

        let rows = 1
        let columns = 2
        let time: TimeInterval = 3

        let viewModel = BaseSlidingViewModel(time: time, gameData: gameData, tiles: ["a", "b"],
                                          rows: rows, columns: columns)
        let delegate = SlidingGameViewControllerDelegateMock()
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
}
