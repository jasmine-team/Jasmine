/// Manages the tiles on the grid
class TetrisGrid {

    private var tiles: [Coordinate: String] = [:]

    func getTileText(at coordinate: Coordinate) -> String? {
        return tiles[coordinate]
    }

    func hasTile(at coordinate: Coordinate) -> Bool {
        return tiles[coordinate] != nil
    }

    func addTile(at coordinate: Coordinate, tileText: String) {
        tiles[coordinate] = tileText
    }

    func removeTile(at coordinate: Coordinate) -> String? {
        guard let removedValue = tiles.removeValue(forKey: coordinate) else {
            return nil
        }
        return removedValue
    }

    func removeTiles(at coordinates: Set<Coordinate>) {
        for coordinate in coordinates {
            _ = removeTile(at: coordinate)
        }
    }
}
