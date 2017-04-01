import Foundation
import UIKit.UIGestureRecognizerSubclass

/// Builds on top of UIPanGestureRecognizer that locks to a direction in `Direction` enum on panning.
class UIDirectionalPanGestureRecognizer: UIPanGestureRecognizer {

    // MARK: - Properties
    private(set) var initialTouchedLocation: CGPoint = .zero

    private(set) var initialTouchedDirection: Direction?

    private(set) var currentTouchedLocation: CGPoint = .zero

    private(set) var touchedLocations: [(point: CGPoint, direction: Direction)]!

    private var originalTouchLocations: [UITouch: CGPoint]!
    private var originalTouchDirections: [UITouch: Direction]!

    // MARK: - Constructors
    /// Overrides the constructor supporting a minimum and maximum number of touches as 1.
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        self.maximumNumberOfTouches = 1
        self.minimumNumberOfTouches = 1
    }

    // MARK: - Touch events
    /// Resets the direction when touch begins.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        assert(touches.count == 1, "Only support 1 touch.")

        originalTouchLocations = [:]
        originalTouchDirections = [:]
        touchedLocations = []
        touches.forEach {
            let location = $0.location(in: view)
            originalTouchLocations[$0] = location
            touchedLocations.append((location, .centre))
        }

        initialTouchedLocation = location(in: view)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        assert(touches.count == 1, "Only support 1 touch.")

        touchedLocations = []
        currentTouchedLocation = location(in: view)

        for touch in touches {
            if !originalTouchDirections.keys.contains(touch) {
                originalTouchDirections[touch] = inferCurrentDirection(with: touch)
            }
            guard let direction = originalTouchDirections[touch],
                  let oldPosition = originalTouchLocations[touch] else {
                continue
            }
            let newPosition = touch.location(in: view)

            if direction.isHorizontal {
                touchedLocations.append((CGPoint(x: newPosition.x, y: oldPosition.y), direction))
            } else if direction.isVertical {
                touchedLocations.append((CGPoint(x: oldPosition.x, y: newPosition.y), direction))
            }
        }

        print(touchedLocations)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        touchedLocations = []
        touches.forEach {
            touchedLocations.append(($0.location(in: view), .centre))
        }
        state = .ended
    }

    // MARK: - Helper Methods
    private func inferCurrentDirection(with velocity: CGVector) -> Direction? {
        guard velocity != .zero else {
            return nil
        }
        let isVertical = fabs(velocity.dy) > fabs(velocity.dx)
        if isVertical {
            return velocity.dy > 0 ? .southwards : .northwards
        } else {
            return velocity.dx > 0 ? .eastwards : .westwards
        }
    }

    private func inferCurrentDirection(with uiTouch: UITouch) -> Direction? {
        let vector = uiTouch.location(in: view).sub(uiTouch.previousLocation(in: view))
        return inferCurrentDirection(with: vector)
    }
}
