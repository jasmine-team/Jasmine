import Foundation
import UIKit

// MARK: - Direction Enumeration
extension UISwipeGestureRecognizerDirection {

    var toDirection: Direction {
        if self == .up {
            return .northwards
        } else if self == .down {
            return .southwards
        } else if self == .left {
            return .westwards
        } else if self == .right {
            return .eastwards
        } else {
            fatalError("Invalid direction.")
        }
    }
}
