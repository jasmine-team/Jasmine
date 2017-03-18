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

    /// Initialise a coordinate based on a flattened array-like index, starting from 0, and 
    /// `maxColumnCount`.
    ///
    /// - Parameters:
    ///   - index: an index >= 0 to be converted.
    ///   - maxColumnCount: maximum number of items in a row. Must be positive.
    init(index: Int, withNumCol maxColumnCount: Int) {
        guard index >= 0, maxColumnCount >= 1 else {
            assertionFailure("Index should be >= 0, maxColumnCount should be >= 1.")
            self.init(index: 0, withNumCol: 1)
            return
        }
        let row = index / maxColumnCount
        let col = index % maxColumnCount
        self.init(row: row, col: col)
    }

    /// Computes the flattened array-like index starting from index 0 based on the `maxColumnCount`.
    ///
    /// - Parameter maxColumnCount: the maximum number of items possible in a row.
    /// - Returns: the index based on the `maxColumnCount`, starting from index 0.
    func toIndex(withNumCol maxColumnCount: Int) -> Int {
        guard maxColumnCount > col else {
            assertionFailure("maxColumnCount should be > col.")
            return 0
        }
        return row * maxColumnCount + col
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
