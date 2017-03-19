import XCTest
@testable import Jasmine

class BaseGameViewControllerDelegateMock: BaseGameViewControllerDelegate {
    fileprivate(set) var score: Int = 0
    fileprivate(set) var remainingTime: TimeInterval = 0
    fileprivate(set) var totalTime: TimeInterval = 0
    fileprivate(set) var status: GameStatus = .notStarted

    func redisplay(newScore: Int) {
        score = newScore
    }

    func redisplay(timeRemaining: TimeInterval, outOf totalTime: TimeInterval) {
        remainingTime = timeRemaining
        self.totalTime = totalTime
    }

    func notifyGameStatus(with newStatus: GameStatus) {
        status = newStatus
    }
}

class CountDownTimerTest: XCTestCase {

    func testInit() {
        let totalTimeAllowed = 10.5
        let timer = CountDownTimer(totalTimeAllowed: totalTimeAllowed)

        XCTAssertEqual(timer.totalTimeAllowed, totalTimeAllowed, "Total time allowed in init is wrong")
        XCTAssertEqual(timer.timeRemaining, totalTimeAllowed, "Time remaining in init is wrong")
        XCTAssertEqual(timer.timeElapsed, 0, "Time elapsed in init is wrong")
    }

    func testStartTimer() {
        let timerInterval: TimeInterval = 1
        let totalTimeAllowed: TimeInterval = 2 * timerInterval

        let timer = CountDownTimer(totalTimeAllowed: totalTimeAllowed)
        let delegate = BaseGameViewControllerDelegateMock()

        timer.startTimer(timerInterval: timerInterval, viewControllerDelegate: delegate)
        XCTAssertEqual(GameStatus.inProgress, delegate.status,
                       "Delegate status is not set to inProgress when timer starts")
        XCTAssertEqual(timer.totalTimeAllowed, delegate.totalTime,
                       "Total time allowed is not set to the timer's total time")

        RunLoop.current.run(until: Date(timeIntervalSinceNow: timerInterval))
        XCTAssertEqual(GameStatus.inProgress, delegate.status,
                       "Delegate status is not set to inProgress when timer starts")
        XCTAssertEqual(timer.timeRemaining, totalTimeAllowed - timerInterval,
                       "Timer does not count down properly")
        XCTAssertEqual(timer.totalTimeAllowed, delegate.totalTime,
                       "Total time allowed is not set to the timer's total time")

        RunLoop.current.run(until: Date(timeIntervalSinceNow: timerInterval))
        XCTAssertEqual(timer.totalTimeAllowed, delegate.totalTime,
                       "Total time allowed is not set to the timer's total time")
        XCTAssertEqual(GameStatus.endedWithLost, delegate.status,
                       "Delegate status is not set to endedWithLost when time's up")
    }
}
