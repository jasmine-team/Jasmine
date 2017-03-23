import Foundation
@testable import Jasmine

struct CountdownTimableMock: CountdownTimable {
    let timer: CountDownTimer = CountDownTimer(totalTimeAllowed: 0)
}
