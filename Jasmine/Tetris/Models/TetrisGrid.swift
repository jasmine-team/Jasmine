/// Manages the tiles on the grid
class TetrisGrid {

    private var tiles: [Coordinate: String] = [:]

    func get(at coordinate: Coordinate) -> String? {
        return tiles[coordinate]
    }

    func hasTile(at coordinate: Coordinate) -> Bool {
        return tiles[coordinate] != nil
    }

    func add(at coordinate: Coordinate, tileText: String) {
        tiles[coordinate] = tileText
    }

    @discardableResult
    func remove(at coordinate: Coordinate) -> String {
        guard let removedValue = tiles.removeValue(forKey: coordinate) else {
            fatalError("Grid has no tile at \(coordinate)")
        }
        return removedValue
    }
}
