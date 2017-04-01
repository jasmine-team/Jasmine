import Foundation

/// A basic enumeration for direction.
enum Direction {
    case northwards
    case southwards
    case eastwards
    case westwards

    /// Returns true if the direction is horizontal.
    var isHorizontal: Bool {
        return self == .eastwards || self == .westwards
    }

    /// Returns true if the direction is vertical.
    var isVertical: Bool {
        return self == .northwards || self == .southwards
    }
}
