import XCTest
import Foundation
@testable import Jasmine

class BaseSlidingViewModelTests: XCTestCase {

    var gameData: GameData!
    let rows = 1
    let columns = 2
    let time: TimeInterval = 3
    var viewModel: BaseSlidingViewModel!

    override func setUp() {
        guard let gameData = try? GameDataFactory().createGame(difficulty: 1, type: .chengYu) else {
            XCTFail("Realm errors")
            return
        }
        self.gameData = gameData

        viewModel = BaseSlidingViewModel(time: time, gameData: gameData, tiles: ["a", nil],
                                         rows: rows, columns: columns)
    }

    func testInit() {
        XCTAssertEqual(0, viewModel.moves,
                       "ViewModel moves on init is not zero")
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
        XCTAssert(["a", nil].contains { $0 == gridData[Coordinate(row: 0, col: 0)] },
                  "Grid Data is not correct")
        XCTAssert(["a", nil].contains { $0 == gridData[Coordinate(row: 0, col: 1)] },
                  "Grid Data is not correct")
    }

    func testStartGame() {
        viewModel.startGame()

        XCTAssertEqual(GameStatus.inProgress, viewModel.gameStatus,
                       "ViewModel game status when the game runs is not inProgress")

        RunLoop.current.run(until: Date(timeIntervalSinceNow: time + 1))
        XCTAssertEqual(GameStatus.endedWithLost, viewModel.gameStatus,
                       "ViewModel game status when time's up is not endedWithLost")
    }

    func testCanTileSlide() {
        let grid = [String?](repeating: "a", count: 12) + [String?](repeating: nil, count: 4)

        let rows = 4
        let columns = 4

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

                    var result: [Direction: Coordinate] = [
                        .northwards: Coordinate(row: row - 1, col: col),
                        .southwards: Coordinate(row: row + 1, col: col),
                        .westwards: Coordinate(row: row, col: col - 1),
                        .eastwards: Coordinate(row: row, col: col + 1)
                    ]

                    for (dir, coord) in result {
                        if !gridData.isInBounds(coordinate: coord) || gridData[coord] != nil {
                            result[dir] = nil
                        }
                    }

                    XCTAssertEqual(result, viewModel.canTileSlide(from: coordinate),
                                   "canTileSlide on \(coordinate) is wrong.")
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
        let grid = [String?](repeating: "a", count: 15) + [String?](repeating: nil, count: 1)

        let rows = 4
        let columns = 4

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

                for coord in [Coordinate(row: row - 1, col: col), Coordinate(row: row + 1, col: col),
                              Coordinate(row: row, col: col - 1), Coordinate(row: row, col: col + 1)] {
                    if gridData.isInBounds(coordinate: coord) {
                        slideTileHelper(viewModel: viewModel, gridData: gridData,
                                        from: coord, to: coordinate)
                    }
                }
            }
        }
    }

    func testScore() {
        XCTAssertEqual(10_300, viewModel.score)
        if viewModel.gridData[Coordinate(row: 0, col: 0)] != nil {
            viewModel.slideTile(from: Coordinate(row: 0, col: 0), to: Coordinate(row: 0, col: 1))
        } else {
            viewModel.slideTile(from: Coordinate(row: 0, col: 1), to: Coordinate(row: 0, col: 0))
        }
        XCTAssertEqual(10_275, viewModel.score)

        viewModel.startGame()
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        XCTAssert(abs(10_175 - viewModel.score) <= 20)
    }
}
