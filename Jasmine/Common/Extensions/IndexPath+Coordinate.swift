import Foundation

// MARK: - Coordinates
extension IndexPath {

    init(_ coordinate: Coordinate) {
        self.init(item: coordinate.col, section: coordinate.row)
    }

    /// Obtains the coordinate from index path.
    var toCoordinate: Coordinate {
        return Coordinate(row: section, col: item)
    }
}
