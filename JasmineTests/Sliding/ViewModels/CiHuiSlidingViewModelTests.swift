import XCTest
@testable import Jasmine

class CiHuiSlidingViewModelTests: RealmTestCase {
    func testInit() {
        let numberOfPhrases = 3

        let gameData = createGameData(difficulty: 1, type: .ciHui)
        let viewModel = CiHuiSlidingViewModel(time: 10, gameData: gameData, rows: numberOfPhrases)

        XCTAssertEqual(0, viewModel.currentScore,
                       "ViewModel currentScore on init is not zero")
        XCTAssertEqual(10, viewModel.timeRemaining,
                       "ViewModel timeRemaining on init is not correct")
        XCTAssertEqual(10, viewModel.totalTimeAllowed,
                       "ViewModel timeRemaining on init is not correct")
        XCTAssertEqual(GameStatus.notStarted, viewModel.gameStatus,
                       "ViewModel gameStatus on init is not correct")
        XCTAssertEqual(viewModel.levelName, gameData.name, "ViewModel level name on init is not correct")
        XCTAssertEqual(viewModel.gameInstruction, GameConstants.Sliding.CiHui.gameInstruction,
                       "ViewModel gameInstruction on init is not correct")
    }
}
