import Foundation
import UIKit

// MARK: - Geometry and Arithmetic Methods
extension CGRect {

    /// Specifies the center of a rectangle.
    var center: CGPoint {
        set {
            origin = CGPoint(x: newValue.x - size.width / 2, y: newValue.y - size.height / 2)
        }
        get {
            return CGPoint(x: midX, y: midY)
        }
    }

    /// Initialise with the center of the rectangle and size.
    init(center: CGPoint, size: CGSize) {
        self.init()
        self.size = size
        self.center = center
    }

    /// Initialise the rectangle with the specified inputs.
    ///
    /// - Parameters:
    ///   - minX: the smaller x-coordinate value
    ///   - maxX: the larger x-coordinate value
    ///   - minY: the smaller y-coordinate value
    ///   - maxY: the larger y-coordinate value
    init(minX: CGFloat, maxX: CGFloat, minY: CGFloat, maxY: CGFloat) {
        self.init(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
    }
}
