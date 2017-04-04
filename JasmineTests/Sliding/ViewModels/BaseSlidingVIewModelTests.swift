import XCTest
import Foundation
@testable import Jasmine

class BaseSlidingViewModelTests: XCTestCase {
    func testInit() {
        guard let gameData = try? GameDataFactory().createGame(difficulty: 1, type: .chengYu) else {
            XCTFail("Realm errors")
            return
        }

        let viewModel = BaseSlidingViewModel(time: 3, gameData: gameData,
                                             tiles: ["a", "b"], rows: 1, columns: 2)

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
        viewModel.startGame()

        XCTAssertEqual(GameStatus.inProgress, viewModel.gameStatus,
                       "ViewModel game status when the game runs is not inProgress")

        RunLoop.current.run(until: Date(timeIntervalSinceNow: time + 1))
        XCTAssertEqual(GameStatus.endedWithLost, viewModel.gameStatus,
                       "ViewModel game status when time's up is not endedWithLost")
    }

    func testCanTileSlide() {
        guard let gameData = try? GameDataFactory().createGame(difficulty: 1, type: .chengYu) else {
            XCTFail("Realm errors")
            return
        }

        let grid = [String?](repeating: "a", count: 12) + [String?](repeating: nil, count: 4)

        let rows = 4
        let columns = 4
        let time: TimeInterval = 3

        for _ in 0..<3 { // do this 3 times due to randomness
            let viewModel = BaseSlidingViewModel(time: time, gameData: gameData, tiles: grid,
                                                 rows: rows, columns: columns)
            let gridData = viewModel.gridData

            for row in 0..<rows {
                for col in 0..<columns {
                    let coordinate = Coordinate(row: row, col: col)

                    if !gridData.isInBounds(coordinate: coordinate) || gridData[coordinate] == nil {
                        XCTAssertEqual([:], viewModel.canTileSlide(from: coordinate))
                        continue
                    }

                    // From here onwards, the coordinate is in the grid data, and the contents is not nil.
                    // Just need to check if the neighbors are in the grid and contents are nil.

                    var result: [Direction: Coordinate] = [:]

                    let top = Coordinate(row: row - 1, col: col)
                    let bottom = Coordinate(row: row + 1, col: col)
                    let left = Coordinate(row: row, col: col - 1)
                    let right = Coordinate(row: row, col: col + 1)

                    if gridData.isInBounds(coordinate: top) && gridData[top] == nil {
                        result[.northwards] = top
                    }
                    if gridData.isInBounds(coordinate: bottom) && gridData[bottom] == nil {
                        result[.southwards] = bottom
                    }
                    if gridData.isInBounds(coordinate: left) && gridData[left] == nil {
                        result[.westwards] = left
                    }
                    if gridData.isInBounds(coordinate: right) && gridData[right] == nil {
                        result[.eastwards] = right
                    }

                    XCTAssertEqual(result, viewModel.canTileSlide(from: coordinate),
                                   "canTileSlide on \(coordinate) (\(gridData[coordinate])) is wrong.")
                }
            }
        }
    }

    func slideTileHelper(viewModel: BaseSlidingViewModel, gridData: TextGrid,
                         from start: Coordinate, to end: Coordinate) {
        XCTAssert(viewModel.slideTile(from: start, to: end))
        XCTAssertEqual(gridData[start], viewModel.gridData[end])
        XCTAssertEqual(gridData[end], viewModel.gridData[start])
        viewModel.slideTile(from: end, to: start)
    }

    func testSlideTile() {
        guard let gameData = try? GameDataFactory().createGame(difficulty: 1, type: .chengYu) else {
            XCTFail("Realm errors")
            return
        }

        let grid = [String?](repeating: "a", count: 15) + [String?](repeating: nil, count: 1)

        let rows = 4
        let columns = 4
        let time: TimeInterval = 3

        let viewModel = BaseSlidingViewModel(time: time, gameData: gameData, tiles: grid,
                                             rows: rows, columns: columns)

        let gridData = viewModel.gridData

        XCTAssertFalse(viewModel.slideTile(from: Coordinate(row: 0, col: 0),
                                           to: Coordinate(row: 0, col: 2)))

        for row in 0..<rows {
            for col in 0..<columns {
                let coordinate = Coordinate(row: row, col: col)
                if gridData[coordinate] != nil {
                    continue
                }

                let top = Coordinate(row: row - 1, col: col)
                let bottom = Coordinate(row: row + 1, col: col)
                let left = Coordinate(row: row, col: col - 1)
                let right = Coordinate(row: row, col: col + 1)

                if gridData.isInBounds(coordinate: top) {
                    slideTileHelper(viewModel: viewModel, gridData: gridData,
                                    from: top, to: coordinate)
                }
                if gridData.isInBounds(coordinate: bottom) {
                    slideTileHelper(viewModel: viewModel, gridData: gridData,
                                    from: bottom, to: coordinate)
                }
                if gridData.isInBounds(coordinate: left) {
                    slideTileHelper(viewModel: viewModel, gridData: gridData,
                                    from: left, to: coordinate)
                }
                if gridData.isInBounds(coordinate: right) {
                    slideTileHelper(viewModel: viewModel, gridData: gridData,
                                    from: right, to: coordinate)
                }
            }
        }
    }
}
