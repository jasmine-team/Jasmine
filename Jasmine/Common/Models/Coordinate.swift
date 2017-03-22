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
            fatalError("Row and column coordinates should be >= 0")
        }
        self.row = row
        self.col = col
    }

    /// Compares a coordinate with another coordinate. Returns true if and only if self < other.
    /// Here comparison is done by looking at the row, then by column.
    ///
    /// - Parameter other: the other coordinate to be compared
    /// - Returns: true if and only if self < other
    func isLessThanByRowFirst(_ other: Coordinate) -> Bool {
        if row == other.row {
            return col < other.col
        } else {
            return row < other.row
        }
    }
}

extension Coordinate: Hashable {
    /// Returns the hash value of this coordinate data structure.
    var hashValue: Int {
        return row ^ col
    }
}

extension Coordinate: Equatable {
    /// Returns true when two coordinates are equal.
    static func == (_ lhs: Coordinate, _ rhs: Coordinate) -> Bool {
        return lhs.row == rhs.row
            && lhs.col == rhs.col
    }
}
