import Foundation
import UIKit

/// Stores the utility methods related to geometry.
struct GeometryUtils {

    /// Gets the origin from the center point.
    /// Note that negative size is not supported, since it's senseless and it's behaviour is not
    /// guaranteed.
    ///
    /// - Parameters:
    ///   - center: the center that is used to derive the origin
    ///   - size: the size of the rectangle that contains both the center and the
    ///     origin.
    /// - Returns: the origin coordinate.
    static func getOrigin(from center: CGPoint, withSize size: CGSize) -> CGPoint {
        return CGPoint(x: center.x - size.width / 2,
                       y: center.y - size.height / 2)
    }
}
