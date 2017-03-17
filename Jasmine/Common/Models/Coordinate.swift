import Foundation

/// Defines a coordinate system that is zero-indexed, where the top left corner has the coordinate
/// row = 0, col = 0.
struct Coordinate {

    /// Defines the origin of the coordinate system, which is zero.
    static let origin = Coordinate(row: 0, col: 0)

    let row: Int
    let col: Int
}

extension Coordinate: Hashable {
    /// Returns the hash value of this coordinate data structure.
    var hashValue: Int {
        return "\(row) \(col)".hashValue
    }
}

extension Coordinate: Equatable {
    /// Returns true when two coordinates are equal.
    static func ==(_ coord1: Coordinate, _ coord2: Coordinate) -> Bool {
        return coord1.row == coord2.row
            && coord1.col == coord2.col
    }
}
