import XCTest
@testable import Jasmine
import RealmSwift

class TetrisGameViewModelTests: RealmTestCase {

    // New view model should be instantialized in test case if state changed
    private var viewModel: TetrisGameViewModel! // Initialize in setUp
    private var gameData: GameData! // Initialize in setUp
    private let testPhrases = [["脱", "颖", "而", "出"], ["司", "空", "见", "惯"]]
    private let tetrisGameViewControllerMock = TetrisGameViewControllerMock()

    override func setUp() {
        super.setUp()
        let phrases = testPhrases.map { Phrase(value: ["chinese": $0.joined()]) }
        gameData = createGameData(phrases: phrases, difficulty: 1, type: .chengYu)
        viewModel = TetrisGameViewModel(gameData: gameData)
        viewModel.timeDelegate = tetrisGameViewControllerMock
        viewModel.scoreDelegate = tetrisGameViewControllerMock
        viewModel.gameStatusDelegate = tetrisGameViewControllerMock
    }

    func testInit() {
        XCTAssert(testPhrases.sorted { $0.joined() > $1.joined() } ==
                  viewModel.phrasesTested.map { $0.chinese.characters.map { String($0) } }
                                         .sorted { $0.joined() > $1.joined() },
                  "ViewModel phrasesTested on init is not correct")
        XCTAssertEqual(viewModel.currentScore, 0,
                       "ViewModel currentScore on init is not zero")
        XCTAssertEqual(viewModel.totalTimeAllowed, Constants.Game.Tetris.totalTime,
                       "ViewModel timer on init is not correct")
        XCTAssertEqual(viewModel.timeRemaining, Constants.Game.Tetris.totalTime,
                       "ViewModel timer on init is not correct")
        XCTAssertEqual(viewModel.gameStatus, GameStatus.notStarted,
                       "ViewModel gameStatus on init is not correct")
        XCTAssertEqual(viewModel.gameTitle, Constants.Game.Tetris.gameTitle,
                       "ViewModel gameTitle on init is not correct")
        XCTAssertEqual(viewModel.gameInstruction, Constants.Game.Tetris.gameInstruction,
                       "ViewModel gameInstruction on init is not correct")
        XCTAssert(Set(testPhrases.flatMap { $0 }).isSuperset(of: viewModel.upcomingTiles),
                       "ViewModel upcomingTiles on init is not correct")
        XCTAssert(testPhrases.flatMap { $0 }.contains(viewModel.fallingTileText),
                  "ViewModel fallingTileText is not initialized properly")
    }

    func testGetNewTileCoordinate() {
        for _ in 0..<10 {
            XCTAssert((0..<Constants.Game.Tetris.columns).map { Coordinate(row: 0, col: $0) }
                                                         .contains(viewModel.getNewTileCoordinate()),
                      "getNewTileCoordinate returned wrong value")
        }
    }

    func testCanShiftFallingTile() {
        XCTAssertTrue(viewModel.canShiftFallingTile(to: Coordinate(row: 0, col: 0)),
                      "canShiftFallingTile wrongly returned false")
    }

    func testCanShiftFallingTileFail() {
        XCTAssertTrue(viewModel.canShiftFallingTile(to: Coordinate(row: 0, col: 0)),
                      "canShiftFallingTile wrongly returned false")
    }

    func testSwapTiles() {
        let originalUpcomingTiles = viewModel.upcomingTiles
        let swapIndex: Int = 1
        guard let fallingTileText = viewModel.fallingTileText else {
            XCTAssert(false, "Failed to get falling tile text")
            return
        }
        let upcomingTileText = viewModel.upcomingTiles[swapIndex]
        viewModel.swapFallingTile(withUpcomingAt: swapIndex)
        XCTAssertEqual(viewModel.fallingTileText, upcomingTileText, "Tile not successfully swapped")
        XCTAssertEqual(viewModel.upcomingTiles, originalUpcomingTiles[0..<swapIndex] + Array([fallingTileText]) +
                                                originalUpcomingTiles[(swapIndex + 1)..<originalUpcomingTiles.count],
                       "Tile not successfully swapped")
    }

    func testCanLandTile() {
        let viewModel = TetrisGameViewModel(gameData: gameData)
        let landingCoordinate = Coordinate(row: Constants.Game.Tetris.rows - 1, col: 0)
        XCTAssert(viewModel.canLandTile(at: landingCoordinate), "canLandTile returns wrong result")

        _ = viewModel.landTile(at: landingCoordinate)
        XCTAssert(viewModel.canLandTile(at: Coordinate(row: landingCoordinate.row - 1, col: 0)),
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

    func testGetLandingCoordinate(from coordinate: Coordinate) {
        let viewModel = TetrisGameViewModel(gameData: gameData)
        let landedCoordinate = Coordinate(row: Constants.Game.Tetris.rows - 1, col: 0)
        XCTAssertEqual(viewModel.getLandingCoordinate(from: Coordinate(row: 0, col: 0)), landedCoordinate,
                       "canLandTile returns wrong result")

        _ = viewModel.landTile(at: landedCoordinate)
        XCTAssertEqual(viewModel.getLandingCoordinate(from: Coordinate(row: 0, col: 0)),
                       Coordinate(row: landedCoordinate.row - 2, col: 0), "getLandingCoordinate returns wrong result")
    }

    func testLandTile() {
        let viewModel = TetrisGameViewModel(gameData: gameData)
        let upcomingTiles = viewModel.upcomingTiles
        XCTAssert(viewModel.landTile(at: Coordinate(row: Constants.Game.Tetris.rows - 1, col: 0)).isEmpty,
                  "tile landed wrongly")
        XCTAssertEqual(viewModel.fallingTileText, upcomingTiles.first, "Failed to get new tile after landing")
        XCTAssertEqual(viewModel.upcomingTiles[0..<upcomingTiles.count - 1], upcomingTiles[1..<upcomingTiles.count],
                       "New upcoming tiles generated after landing are wrong")
    }

    func testDestroyTiles() {
        var landedCoordinates: Set<Coordinate> = []
        var destroyedAndShiftedTiles: [(destroyedTiles: Set<Coordinate>,
                                        shiftedTiles: [(from: Coordinate, to: Coordinate)])] = []
        let testWords = testPhrases.flatMap { $0 }
        for _ in 0..<testWords.count {
            guard let columnToLand = testWords.index(of: viewModel.fallingTileText) else {
                XCTAssert(false, "Falling tile text is invalid")
                return
            }
            let landingCoordinate = Coordinate(row: Constants.Game.Tetris.rows - 1, col: columnToLand)
            landedCoordinates.insert(landingCoordinate)
            destroyedAndShiftedTiles += viewModel.landTile(at: landingCoordinate)
        }
        print(destroyedAndShiftedTiles.map { $0.destroyedTiles })
        XCTAssertEqual(Set(destroyedAndShiftedTiles.map { $0.destroyedTiles }.flatMap { $0 }), landedCoordinates,
                       "Tiles destroyed are wrong")
        XCTAssertEqual(viewModel.currentScore, 8)
    }

    func testStartGame() {
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
}
