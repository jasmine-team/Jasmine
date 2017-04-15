import XCTest
@testable import Jasmine

class CiHuiSwappingViewModelTests: RealmTestCase {
    func testInit() {
        let numberOfPhrases = 3

        let gameData = createGameData(difficulty: 1, type: .ciHui)
        let viewModel = CiHuiSwappingViewModel(time: 10, gameData: gameData,
                                               numberOfPhrases: numberOfPhrases)

        XCTAssertEqual(0, viewModel.currentScore,
                       "ViewModel currentScore on init is not zero")
        XCTAssertEqual(10, viewModel.timeRemaining,
                       "ViewModel timeRemaining on init is not correct")
        XCTAssertEqual(10, viewModel.totalTimeAllowed,
                       "ViewModel timeRemaining on init is not correct")
        XCTAssertEqual(GameStatus.notStarted, viewModel.gameStatus,
                       "ViewModel gameStatus on init is not correct")
        XCTAssertEqual(viewModel.gameTitle, String(format: GameConstants.Swapping.CiHui.gameTitle, gameData.name),
                       "ViewModel gameTitle on init is not correct")
        XCTAssertEqual(viewModel.gameInstruction, GameConstants.Swapping.CiHui.gameInstruction,
                       "ViewModel gameInstruction on init is not correct")
    }
}
