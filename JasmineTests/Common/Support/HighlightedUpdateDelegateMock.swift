@testable import Jasmine

class HighlightedUpdateDelegateMock: HighlightedUpdateDelegate {

    private(set) var highlightedUpdated = 0

    /// Tells the implementor of the delegate that the highlighted coordinates have been changed.
    /// - Note: This method can be used to update the highlighted coordinates that is displayed on views.
    func highlightedCoordinatesDidUpdate() {
        highlightedUpdated += 1
    }
}
