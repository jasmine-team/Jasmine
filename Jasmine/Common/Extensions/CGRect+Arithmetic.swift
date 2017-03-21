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
            return CGPoint(x: origin.x + width / 2, y: origin.y + height / 2)
        }
    }

    /// Initialise with the center of the rectangle and size.
    init(center: CGPoint, size: CGSize) {
        self.init()
        self.size = size
        self.center = center
    }
}
