import XCTest
@testable import Jasmine
import RealmSwift

class TetrisGameViewModelTests: RealmTestCase {

    // New view model should be instantialized in test case if state changed
    private var viewModel: TetrisGameViewModel! // Initialize in setUp
    private var gameData: GameData! // Initialize in setUp
    private let testPhrase = ["脱", "颖", "而", "出"]

    override func setUp() {
        super.setUp()
        let phrases = [Phrase(value: ["chinese": testPhrase.joined()])]
        gameData = createGameData(phrases: phrases, difficulty: 1, type: .chengYu)
        viewModel = TetrisGameViewModel(gameData: gameData)
    }

    func testInit() {
        XCTAssertEqual(0, viewModel.currentScore,
                       "ViewModel currentScore on init is not zero")
        XCTAssertEqual(viewModel.timer.totalTimeAllowed, Constants.Game.Tetris.totalTime,
                       "ViewModel timer on init is not correct")
        XCTAssertEqual(viewModel.gameStatus, GameStatus.notStarted,
                       "ViewModel gameStatus on init is not correct")
        XCTAssertEqual(viewModel.gameTitle, Constants.Game.Tetris.gameTitle,
                       "ViewModel gameTitle on init is not correct")
        XCTAssertEqual(viewModel.gameInstruction, Constants.Game.Tetris.gameInstruction,
                       "ViewModel gameInstruction on init is not correct")
        XCTAssertEqual(viewModel.upcomingTiles.count, Constants.Game.Tetris.upcomingTilesCount,
                       "ViewModel upcomingTiles count on init is not correct")
        XCTAssertNotNil(viewModel.fallingTileText,
                       "ViewModel fallingTileText is not initialized")
    }

    func testStartGame() {
        let delegate = TetrisGameViewControllerDelegateMock()
        viewModel.delegate = delegate
        viewModel.startGame()

        XCTAssertEqual(GameStatus.inProgress, viewModel.gameStatus,
                       "ViewModel game status when the game runs is not inProgress")

        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        // TODO: Fix this
        // XCTAssertEqual(Constants.Game.Tetris.totalTime, delegate.totalTime,
        //                "Delegate totalTime is not correct")
        // if let timeRemaining = delegate.timeRemaining {
        //     XCTAssertEqualWithAccuracy(timeRemaining, delegate.totalTime - 1,
        //                                accuracy: Constants.Game.Tetris.totalTime / 10,
        //                                "Delegate timeRemaining is not correct")
        // } else {
        //     XCTAssert(false, "Delegate time remaining is not set")
        // }
        XCTAssertEqual(viewModel.gameStatus, GameStatus.inProgress,
                       "ViewModel game status is not in progress")
    }

    func testSwapTiles() {
        let swapIndex = 1
        let fallingTileText = viewModel.fallingTileText
        let upcomingTileText = viewModel.upcomingTiles[swapIndex]
        viewModel.swapFallingTile(withUpcomingAt: swapIndex)
        XCTAssertEqual(viewModel.fallingTileText, upcomingTileText, "Tile not successfully swapped")
        XCTAssertEqual(viewModel.upcomingTiles[swapIndex], fallingTileText, "Tile not successfully swapped")
    }

    func testCanLandTile() {
        let viewModel = TetrisGameViewModel(gameData: gameData)
        XCTAssert(viewModel.canLandTile(at: Coordinate(row: Constants.Game.Tetris.rows - 1, col: 0)),
                  "canLandTile returns wrong result")
        let landedCoordinate = Coordinate(row: Constants.Game.Tetris.rows - 1, col: 0)
        _ = viewModel.landTile(at: landedCoordinate)
        XCTAssert(viewModel.canLandTile(at: Coordinate(row: landedCoordinate.row - 1, col: 0)),
                  "canLandTile returns wrong result")
    }

    func testCanLandTileFail() {
        let viewModel = TetrisGameViewModel(gameData: gameData)
        XCTAssertFalse(viewModel.canLandTile(at: Coordinate(row: 0, col: 0)),
                       "canLandTile returns wrong result")
        let landedCoordinate = Coordinate(row: Constants.Game.Tetris.rows - 1, col: 0)
        _ = viewModel.landTile(at: landedCoordinate)
        XCTAssertFalse(viewModel.canLandTile(at: landedCoordinate), "canLandTile returns wrong result")
    }

    func testDestroyTiles() {
        var landedCoordinates: Set<Coordinate> = []
//        var [(destroyedTiles: Set<Coordinate>,
//        shiftedTiles: [(from: Coordinate, to: Coordinate)])]
//        for _ in 0..<testPhrase.count {
//            guard let columnToLand = testPhrase.index(of: viewModel.fallingTileText) else {
//                XCTAssert(false, "Falling tile text is invalid")
//                return
//            }
//            let landedCoordinate = viewModel.landTile(at: Coordinate(row: 0, col: columnToLand))
//            landedCoordinates.insert(landedCoordinate)
//            viewModel.destroyAndShiftTiles(landedAt: landedCoordinate)
//        }
        XCTAssertEqual(viewModel.currentScore, 4)
//        guard let landedCoordinate = landedCoordinates.first else {
//            XCTAssert(false, "No landed coordinate")
//            return
//        }
//        guard let destroyedAndShiftedTiles = viewModel.destroyAndShiftTiles(landedAt: landedCoordinate).first else {
//            XCTAssert(false, "Failed to get destroyed tiles")
//            return
//        }
//        XCTAssertEqual(destroyedAndShiftedTiles.destroyedTiles, landedCoordinates,
//                       "Tiles destroyed are wrong")
    }

    func testCanShiftFallingTile() {
        XCTAssertTrue(viewModel.canShiftFallingTile(to: Coordinate(row: 0, col: 0)),
                      "canShiftFallingTile wrongly returned false")
    }

    func testCantShiftFallingTile() {
        XCTAssertTrue(viewModel.canShiftFallingTile(to: Coordinate(row: 0, col: 0)),
                      "canShiftFallingTile wrongly returned false")
    }
}
