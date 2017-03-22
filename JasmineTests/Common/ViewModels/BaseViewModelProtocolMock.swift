import Foundation
@testable import Jasmine

class TimedViewModelProtocolMock: BaseViewModelProtocol, TimedViewModelProtocol {
    private(set) var currentScore: Int = 0
    var gameStatus: GameStatus = .notStarted
    var timer = CountDownTimer(totalTimeAllowed: 10, viewModel: nil)
    private(set) var totalTimeAllowed: TimeInterval = 0
    private(set) var timeRemaining: TimeInterval = 0
    func startGame() {}
    func timeDidUpdate(timeRemaining: TimeInterval, totalTime: TimeInterval) {
        self.timeRemaining = timeRemaining
        totalTimeAllowed = totalTime
    }
}
