import Foundation

// MARK: - Coordinates
extension IndexPath {

    /// Obtains the coordinate from index path.
    var toCoordinate: Coordinate {
        return Coordinate(row: section, col: item)
    }
}
