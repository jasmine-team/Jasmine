import Foundation
import UIKit

extension CGPoint {

    /// Subtracts another point to get a displacement vector.
    ///
    /// - Parameters:
    ///   - lhs: the point to be subtracted from.
    ///   - rhs: the other point to be subtracted.
    /// - Returns: the resultant vector
    static func - (_ lhs: CGPoint, _ rhs: CGPoint) -> CGVector {
        return CGVector(dx: lhs.x - rhs.x, dy: lhs.y - rhs.y)
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
    /// depending on which axis line is nearer to the current point.
    ///
    /// - Parameter origin: the origin point of the axis.
    /// - Returns: the aligned point.
    func alignToAxis(fromOrigin origin: CGPoint) -> CGPoint {
        var outcome = self
        let displacement = outcome - origin
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
