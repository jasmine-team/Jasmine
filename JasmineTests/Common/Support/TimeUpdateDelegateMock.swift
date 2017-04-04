@testable import Jasmine

class TimeUpdateDelegateMock: TimeUpdateDelegate {

    private(set) var timeUpdated = 0

    /// Tells the implementor of the delegate that the time has been updated.
    /// - Note: This method can be used to update the remaining time that is displayed on views.
    func timeDidUpdate() {
        timeUpdated += 1
    }
}
