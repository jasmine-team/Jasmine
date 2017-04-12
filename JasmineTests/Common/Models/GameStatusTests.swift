import XCTest
@testable import Jasmine

class GameStatusTests: RealmTestCase {
    func hasGameEndedTests() {
        XCTAssert(GameStatus.endedWithWon.hasGameEnded)
        XCTAssert(GameStatus.endedWithLost.hasGameEnded)
        XCTAssertFalse(GameStatus.inProgress.hasGameEnded)
        XCTAssertFalse(GameStatus.notStarted.hasGameEnded)
    }
}
