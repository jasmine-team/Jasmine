import Foundation
import UIKit

extension CGPoint {

    /// Subtracts another point to get a displacement vector.
    ///
    /// - Parameter other: the other point to get displacement.
    /// - Returns: the resultant vector
    func sub(_ other: CGPoint) -> CGVector {
        return CGVector(dx: x - other.x, dy: y - other.y)
    }

    /// Aligns the point within the bounding box, such that if any of the coordinate component
    /// exceeds the bounding box, it will lie on the border of the box.
    ///
    /// - Parameter boundingBox: the box that the point should fall into.
    /// - Returns: the point that is found within the box.
    func fitWithin(boundingBox: CGRect) -> CGPoint {
        var outcome = self
        outcome.y = min(max(outcome.y, boundingBox.minY), boundingBox.maxY)
        outcome.x = min(max(outcome.x, boundingBox.minX), boundingBox.maxX)
        return outcome
    }

    /// Creates a new point that aligns to either the vertical or horizontal axis from the origin
    /// depending on which line is nearer.
    ///
    /// - Parameter origin: the origin point of the axis.
    /// - Returns: the aligned point.
    func alignToAxis(fromOrigin origin: CGPoint) -> CGPoint {
        var outcome = self
        let displacement = outcome.sub(origin)
        let xMagnitude = fabs(displacement.dx)
        let yMagnitude = fabs(displacement.dy)

        if xMagnitude < yMagnitude {
            outcome.x = origin.x
        } else {
            outcome.y = origin.y
        }
        return outcome
    }
}
