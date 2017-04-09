import XCTest
@testable import Jasmine

class ChengYuSwappingViewModelTests: RealmTestCase {
    func testInit() {
        let numberOfPhrases = 3

        let gameData = createGameData(difficulty: 1, type: .chengYu)
        let viewModel = ChengYuSwappingViewModel(time: 10, gameData: gameData,
                                                 numberOfPhrases: numberOfPhrases)

        XCTAssertNil(viewModel.gameStatusDelegate,
                     "ViewModel delegate on init is not nil")
        XCTAssertNil(viewModel.timeDelegate,
                     "ViewModel delegate on init is not nil")
        XCTAssertNil(viewModel.scoreDelegate,
                     "ViewModel delegate on init is not nil")

        XCTAssertEqual(0, viewModel.currentScore,
                       "ViewModel currentScore on init is not zero")
        XCTAssertEqual(10, viewModel.timeRemaining,
                       "ViewModel timeRemaining on init is not correct")
        XCTAssertEqual(10, viewModel.totalTimeAllowed,
                       "ViewModel timeRemaining on init is not correct")
        XCTAssertEqual(GameStatus.notStarted, viewModel.gameStatus,
                       "ViewModel gameStatus on init is not correct")
        XCTAssertEqual("Cheng Yu (成语) Swapping Game", viewModel.gameTitle,
                       "ViewModel gameTitle on init is not correct")
        XCTAssertEqual("Match the Cheng Yus by putting them in one row/column.",
                       viewModel.gameInstruction,
                       "ViewModel gameInstruction on init is not correct")
    }
}
