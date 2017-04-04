import Foundation

protocol TimeDescriptorProtocol {

    // MARK: - Time Remaining
    /// A delegate that notifies the implementing view controller that the time (remaining) has been
    /// updated.
    weak var timeDelegate: TimeUpdateDelegate? { get set }

    /// Specifies the total time allowed in the game.
    var totalTimeAllowed: TimeInterval { get }

    /// Specifies the remaining time left in the game.
    var timeRemaining: TimeInterval { get }
    
}
