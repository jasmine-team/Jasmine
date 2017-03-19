import Foundation

class GridViewModel {

    // Countdown timer for managing game time
    let timer: CountDownTimer

    private let timeLimit: TimeInterval = 10

    init() {
        timer = CountDownTimer(totalTimeAllowed: timeLimit)
    }
}
