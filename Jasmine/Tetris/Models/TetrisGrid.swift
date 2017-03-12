import Foundation

/// Manages the tiles on the grid

class TetrisGrid {

    private var tiles: [IndexPath: TetrisTile] = [:]

    func get(at indexPath: IndexPath) -> TetrisTile? {
        return tiles[indexPath]
    }

    func hasTile(at indexPath: IndexPath) -> Bool {
        return tiles[indexPath] != nil
    }

    func add(_ tile: TetrisTile) {
        tiles[tile.indexPath] = tile
    }

    func remove(at indexPath: IndexPath) {
        tiles[indexPath] = nil
    }

}
