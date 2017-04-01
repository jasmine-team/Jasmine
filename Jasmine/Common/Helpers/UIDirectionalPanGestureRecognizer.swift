import Foundation
import UIKit.UIGestureRecognizerSubclass

/// Builds on top of UIPanGestureRecognizer that locks to a direction in `Direction` enum on panning.
class UIDirectionalPanGestureRecognizer: UIPanGestureRecognizer {

    // MARK: - Properties
    private(set) var direction: Direction?

    private(set) var touchedLocations: [CGPoint]!

    private var uiTouchOriginalLocations: [UITouch: CGPoint]!

    // MARK: - Touch events
    /// Resets the direction when touch begins.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)

        uiTouchOriginalLocations = [:]
        direction = nil

        touches.forEach { touch in
            let location = touch.location(in: view)
            uiTouchOriginalLocations[touch] = location
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)

        if direction == nil {
            direction = inferCurrentDirection()
        }
        guard let direction = self.direction else {
            touchedLocations = touches.map { $0.location(in: view) }
            return
        }

        touchedLocations = []
        for touch in touches {
            let newPosition = touch.location(in: view)
            guard let oldPosition = uiTouchOriginalLocations[touch] else {
                continue
            }
            if direction.isHorizontal {
                touchedLocations.append(CGPoint(x: newPosition.x,
                                                y: oldPosition.y))
            } else if direction.isVertical {
                touchedLocations.append(CGPoint(x: oldPosition.x,
                                                y: newPosition.y))
            }
        }
    }

    // MARK: - Helper Methods
    /// Determines and return the current direction of the pan.
    ///
    /// - Returns: direction of the current pan.
    private func inferCurrentDirection() -> Direction? {
        let currentVelocity = velocity(in: view)
        guard currentVelocity != .zero else {
            return nil
        }

        let isVertical = fabs(currentVelocity.y) > fabs(currentVelocity.x)
        if isVertical {
            return currentVelocity.y > 0 ? .southwards : .northwards
        } else {
            return currentVelocity.x > 0 ? .eastwards : .westwards
        }
    }

}
