import Foundation

/// Defines a coordinate system that is zero-indexed, where the top left corner has the coordinate
/// row = 0, col = 0.
struct Coordinate {

    /// Defines the origin of the coordinate system, which is zero.
    static let origin = Coordinate(row: 0, col: 0)

    let row: Int
    let col: Int

    /// Default constructor for Coordinate.
    init(row: Int, col: Int) {
        guard row >= 0, col >= 0 else {
            assertionFailure("Row and column coordinates should be >= 0")
            self.row = 0
            self.col = 0
            return
        }
        self.row = row
        self.col = col
    }
}

extension Coordinate: Hashable {
    /// Returns the hash value of this coordinate data structure.
    var hashValue: Int {
        return "\(row) \(col)".hashValue
    }
}

extension Coordinate: Equatable {
    /// Returns true when two coordinates are equal.
    static func == (_ lhs: Coordinate, _ rhs: Coordinate) -> Bool {
        return lhs.row == rhs.row
            && lhs.col == rhs.col
    }
}
