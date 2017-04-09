import XCTest
@testable import Jasmine

class CiHuiSlidingViewModelTests: XCTestCase {
    func testInit() {
        let numberOfPhrases = 3

        let level = Level(value: ["rawGameType": "ciHui"])
        guard let gameData = try? GameManager().createGame(fromLevel: level) else {
            XCTFail("Realm errors")
            return
        }

        let viewModel = CiHuiSlidingViewModel(time: 10, gameData: gameData, rows: numberOfPhrases)

        XCTAssertEqual(0, viewModel.currentScore,
                       "ViewModel currentScore on init is not zero")
        XCTAssertEqual(10, viewModel.timeRemaining,
                       "ViewModel timeRemaining on init is not correct")
        XCTAssertEqual(10, viewModel.totalTimeAllowed,
                       "ViewModel timeRemaining on init is not correct")
        XCTAssertEqual(GameStatus.notStarted, viewModel.gameStatus,
                       "ViewModel gameStatus on init is not correct")
        XCTAssertEqual("Ci Hui (词汇) Sliding Game", viewModel.gameTitle,
                       "ViewModel gameTitle on init is not correct")
        XCTAssertEqual("Match the Chinese characters with their Pinyins by putting them in one row/column.",
                       viewModel.gameInstruction,
                       "ViewModel gameInstruction on init is not correct")
    }
}
