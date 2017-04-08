import XCTest
@testable import Jasmine

class ChengYuSlidingViewModelTests: XCTestCase {
    func testInit() {
        let numberOfPhrases = 3

        let level = Level()
        level.gameType = .chengYu
        guard let gameData = try? GameManager().createGame(fromLevel: level) else {
            XCTFail("Realm errors")
            return
        }

        let viewModel = ChengYuSlidingViewModel(time: 10, gameData: gameData, rows: numberOfPhrases)

        XCTAssertEqual(0, viewModel.currentScore,
                       "ViewModel currentScore on init is not zero")
        XCTAssertEqual(10, viewModel.timeRemaining,
                       "ViewModel timeRemaining on init is not correct")
        XCTAssertEqual(10, viewModel.totalTimeAllowed,
                       "ViewModel timeRemaining on init is not correct")
        XCTAssertEqual(GameStatus.notStarted, viewModel.gameStatus,
                       "ViewModel gameStatus on init is not correct")
        XCTAssertEqual("Cheng Yu (成语) Sliding Game", viewModel.gameTitle,
                       "ViewModel gameTitle on init is not correct")
        XCTAssertEqual("Match the Cheng Yus by putting them in one row/column.",
                       viewModel.gameInstruction,
                       "ViewModel gameInstruction on init is not correct")
    }
}
