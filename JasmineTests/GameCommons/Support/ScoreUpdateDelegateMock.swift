@testable import Jasmine

class ScoreUpdateDelegateMock: ScoreUpdateDelegate {

    private(set) var scoreUpdatedCount = 0

    /// Tells the implementor of the delegate that the score has been updated.
    /// - Note: This method can be used to update the current score that is displayed on views.
    func scoreDidUpdate() {
        scoreUpdatedCount += 1
    }
}
