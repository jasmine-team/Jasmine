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
        self.row = row
        self.col = col
    }

    /// Returns the Coordinate of the next row, which is one row down.
    var nextRow: Coordinate {
        return Coordinate(row: row + 1, col: col)
    }

    /// Returns the Coordinate of the previous row, which is one row up.
    var prevRow: Coordinate {
        return Coordinate(row: row - 1, col: col)
    }

    /// Returns the Coordinate of the next column, which is one column to the right.
    var nextCol: Coordinate {
        return Coordinate(row: row, col: col + 1)
    }

    /// Returns the Coordinate of the previous column, which is one column to the left.
    var prevCol: Coordinate {
        return Coordinate(row: row, col: col - 1)
    }

    /// Gets the index path from the current coordinate.
    var toIndexPath: IndexPath {
        return IndexPath(item: col, section: row)
    }

    /// Returns true if this coordinate is found within the specified number of rows and columns.
    func isWithin(numRows: Int, numCols: Int) -> Bool {
        return row >= 0 && row < numRows && col >= 0 && col < numCols
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

extension Coordinate: Comparable {
    /// Compares two Coordinates. Comparison is done by looking at the row, then by column.
    ///
    /// - Parameter other: the other coordinate to be compared
    /// - Returns: true if and only if lhs < rhs
    static func < (_ lhs: Coordinate, _ rhs: Coordinate) -> Bool {
        return lhs.row == rhs.row ? lhs.col < rhs.col
                                  : lhs.row < rhs.row
    }
}
