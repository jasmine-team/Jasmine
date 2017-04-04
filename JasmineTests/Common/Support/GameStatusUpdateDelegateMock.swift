@testable import Jasmine

class GameStatusUpdateDelegateMock: GameStatusUpdateDelegate {

    private(set) var gameStatusUpdated = 0

    // MARK: Game Status
    /// Tells the implementor of the delegate that the game status has been updated.
    /// - Note: This method can be used to update the game status that is displayed on views.
    func gameStatusDidUpdate() {
        gameStatusUpdated += 1
    }
}
