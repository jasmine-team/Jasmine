import XCTest
@testable import Jasmine

class CountDownTimerTest: XCTestCase {

    func testInit() {
        let totalTimeAllowed = 10.5
        let timer = CountDownTimer(totalTimeAllowed: totalTimeAllowed, viewModel: nil)

        XCTAssertEqual(timer.totalTimeAllowed, totalTimeAllowed, "Total time allowed in init is wrong")
        XCTAssertEqual(timer.timeRemaining, totalTimeAllowed, "Time remaining in init is wrong")
    }

    func testStartTimer() {
        let viewModel = TimedViewModelProtocolMock()

        let timer = CountDownTimer(totalTimeAllowed: 2, viewModel: viewModel)
        XCTAssertEqual(timer.timeRemaining, viewModel.timeRemaining,
                       "Timer time remaining is not set to VM time remaining")
        XCTAssertEqual(timer.totalTimeAllowed, viewModel.totalTimeAllowed,
                       "Total time allowed is not set to the timer's total time")

        timer.startTimer(timerInterval: 1)
        XCTAssertEqual(GameStatus.inProgress, viewModel.gameStatus,
                       "ViewModel status is not set to inProgress when timer starts")

        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        XCTAssertEqual(GameStatus.inProgress, viewModel.gameStatus,
                       "ViewModel status is not set to inProgress when timer starts")
        XCTAssertEqual(timer.timeRemaining, 1,
                       "Timer does not count down properly")
        XCTAssertEqual(timer.totalTimeAllowed, viewModel.totalTimeAllowed,
                       "Total time allowed is not set to the timer's total time")

        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1.5))
        XCTAssertEqual(GameStatus.endedWithLost, viewModel.gameStatus,
                       "ViewModel status is not set to endedWithLost when time's up")
        XCTAssertEqual(timer.timeRemaining, 0,
                       "Timer does not count down properly")
        XCTAssertEqual(timer.totalTimeAllowed, viewModel.totalTimeAllowed,
                       "Total time allowed is not set to the timer's total time")
    }
}
