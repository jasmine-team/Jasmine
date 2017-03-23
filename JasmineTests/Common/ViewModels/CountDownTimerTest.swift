import XCTest
@testable import Jasmine

class CountDownTimerTest: XCTestCase {

    func testInit() {
        let totalTimeAllowed = 10.5
        let timer = CountDownTimer(totalTimeAllowed: totalTimeAllowed)

        XCTAssertEqual(timer.totalTimeAllowed, totalTimeAllowed, "Total time allowed in init is wrong")
        XCTAssertEqual(timer.timeRemaining, totalTimeAllowed, "Time remaining in init is wrong")
        XCTAssertNil(timer.timerDidStart, "The function timerDidStart is not nil on init")
        XCTAssertNil(timer.timerDidTick, "The function timerDidTick is not nil on init")
        XCTAssertNil(timer.timerDidFinish, "The function timerDidFinish is not nil on init")
        XCTAssertNil(timer.timerDidStop, "The function timerDidStop is not nil on init")
    }

    func testStartTimer() {
        let timer = CountDownTimer(totalTimeAllowed: 2)

        var started = false
        var ticks = 0
        var finished = false
        timer.timerDidStart = {
            started = true
        }
        timer.timerDidTick = {
            ticks += 1
        }
        timer.timerDidFinish = {
            finished = true
        }

        timer.startTimer(timerInterval: 1)
        XCTAssert(started, "timerDidStart is not fired")

        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        XCTAssertEqual(1, ticks, "timerDidTick is not fired")

        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1.5))
        XCTAssertEqual(2, ticks, "timerDidTick is not fired")
        XCTAssert(finished, "timerDidFinish is not fired")
    }

    func testStopTimer() {
        let timer = CountDownTimer(totalTimeAllowed: 2)

        var stopped = false
        timer.timerDidStop = {
            stopped = true
        }

        timer.startTimer(timerInterval: 1)
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
        timer.stopTimer()

        XCTAssert(stopped, "timerDidStop is not fired")
    }
}
