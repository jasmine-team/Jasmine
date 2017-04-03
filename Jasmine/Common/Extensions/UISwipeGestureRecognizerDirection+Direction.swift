import Foundation
import UIKit

// MARK: - Direction Enumeration
extension UISwipeGestureRecognizerDirection {

    var toDirection: Direction {
        switch self {
        case UISwipeGestureRecognizerDirection.up:
            return .northwards
        case UISwipeGestureRecognizerDirection.down:
            return .southwards
        case UISwipeGestureRecognizerDirection.left:
            return .westwards
        case UISwipeGestureRecognizerDirection.right:
            return .eastwards
        default:
            fatalError("Invalid direction.")
        }
    }
}
