import XCTest
@testable import Jasmine

class CountDownTimerTest: XCTestCase {

    func testInit() {
        let totalTimeAllowed = 10.5
        let timer = CountDownTimer(totalTimeAllowed: totalTimeAllowed)

        XCTAssertEqual(timer.totalTimeAllowed, totalTimeAllowed, "Total time allowed in init is wrong")
        XCTAssertEqual(timer.timeRemaining, totalTimeAllowed, "Time remaining in init is wrong")
    }

    func testStartTimer() {
        let timer = CountDownTimer(totalTimeAllowed: 2)

        var started = false
        var ticks = 0
        var finished = false

        timer.timerListener = { status in
            switch status {
            case .start:
                started = true
            case .tick:
                ticks += 1
            case .finish:
                finished = true
            default:
                break
            }
        }

        timer.startTimer(timerInterval: 1)
        XCTAssert(started, "timerDidStart is not fired")

        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1.5))
        XCTAssertEqual(1, ticks, "timerDidTick is not fired")

        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1.5))
        XCTAssertEqual(2, ticks, "timerDidTick is not fired")
        XCTAssert(finished, "timerDidFinish is not fired")
    }

    func testStopTimer() {
        let timer = CountDownTimer(totalTimeAllowed: 2)

        var stopped = false
        timer.timerListener = { status in
            if status == .stop {
                stopped = true
            }
        }

        timer.startTimer(timerInterval: 1)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        timer.stopTimer()

        XCTAssert(stopped, "timerDidStop is not fired")
    }
}
