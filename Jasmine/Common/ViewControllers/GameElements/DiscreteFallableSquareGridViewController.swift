import UIKit

/// A square grid view controller that builds on the ability to drag a tile and provides
/// functionalities that allows one tile to fall automatically in consistent time interval.
class DiscreteFallableSquareGridViewController: DraggableSquareGridViewController {

    // MARK: - Listeners
    /// Implement this function to get notified when the falling tile has repositioned.
    var onFallingTileRepositioned: ((SquareTileView) -> Void)?

    /// Implement a function that checks if the falling tile should be repositioned.
    /// This function takes a parameter which is the position where the falling tile will be placed,
    /// and returns true if the tile can placed there.
    var canRepositionTile: ((SquareTileView, Coordinate) -> Bool) = { _ in
        return true
    }

    // MARK: - Properties
    /// Stores the current falling tiles. Empty implies that no tile is falling currently.
    private(set) var fallingTiles: Set<SquareTileView> = []

    /// Returns true if there is a falling tile.
    var hasFallingTiles: Bool {
        return !fallingTiles.isEmpty
    }

    /// Returns the coordinate where the falling tile is currently at, if such a falling tile is 
    /// present.
    var fallingTilesCoord: Set<Coordinate> {
        return Set(fallingTiles.flatMap { getCoordinate(from: $0) })
    }

    private var timer = Timer()

    // MARK: - Start and Stop Falling of Tiles
    func startFallingTiles(with interval: TimeInterval) {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            self.allTiles.forEach { self.shiftFallingTileDownwards($0) }
        }
    }

    func pauseFallingTiles() {
        timer.invalidate()
    }

    // MARK: - Adding and Landing Tile Methods
    func addFallingTile(withData data: String, toCoord coordinate: Coordinate) -> SquareTileView? {
        guard let view = super.addDetachedTile(withData: data, toCoord: coordinate) else {
            return nil
        }
        fallingTiles.insert(view)
        return view
    }

    func landFallingTile(_ tile: SquareTileView) {
        guard fallingTiles.remove(tile) != nil else {
            return
        }
        snapAndReattachDetachedTileToNearestCell(tile)
    }

    // MARK: - Shifting Falling Tiles
    func shiftFallingTileLeftwards(_ tile: SquareTileView) {
        guard let coord = getCoordinate(from: tile) else {
            return
        }
        shiftFallingTile(tile, to: coord.prevCol)
    }

    func shiftFallingTileRightwards(_ tile: SquareTileView) {
        guard let coord = getCoordinate(from: tile) else {
            return
        }
        shiftFallingTile(tile, to: coord.nextCol)
    }

    func shiftFallingTileDownwards(_ tile: SquareTileView) {
        guard let coord = getCoordinate(from: tile) else {
            return
        }
        shiftFallingTile(tile, to: coord.nextRow)
    }

    func shiftFallingTile(_ tile: SquareTileView, to coordinate: Coordinate) {
        guard canRepositionTile(tile, coordinate) else {
            return
        }
        snapDetachedTile(tile, toCoordinate: coordinate) {
            self.onFallingTileRepositioned?(tile)
        }
    }
}
