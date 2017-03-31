import Foundation
import UIKit

// MARK: - Direction
extension UIPanGestureRecognizer {

    /// Derive the direction from the panning motion.
    var direction: Direction {
        guard let view = self.view else {
            fatalError("No view attached.")
        }

        let currentVelocity = velocity(in: view)
        guard currentVelocity != .zero else {
            return .centre
        }

        let isVertical = fabs(currentVelocity.y) > fabs(currentVelocity.x)

        if isVertical {
            return currentVelocity.y > 0 ? .southwards : .northwards
        } else {
            return currentVelocity.x > 0 ? .eastwards : .westwards
        }
    }
}
