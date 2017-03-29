import UIKit

/// A square grid view controller that builds on the ability to drag a tile and provides
/// functionalities that allows one tile to fall automatically in consistent time interval.
class DiscreteFallableSquareGridViewController: DraggableSquareGridViewController {

    // MARK: - Listeners
    /// Implement this function to get notified when the falling tile has repositioned.
    var onFallingTileRepositioned: (() -> Void)?

    /// Implement this function to get notified when the falling tile has landed.
    var onFallingTileLanded: (() -> Void)?

    // MARK: - Properties
    /// Stores the current falling tiles. Empty implies that no tile is falling currently.
    private(set) var fallingTile: SquareTileView?

    /// Returns true if there is a falling tile.
    var hasFallingTile: Bool {
        return fallingTile != nil
    }

    /// Returns the coordinate where the falling tile is currently at, if such a falling tile is 
    /// present.
    var fallingTileCoord: Coordinate? {
        guard let fallingTile = fallingTile else {
            return nil
        }
        return getCoordinate(from: fallingTile)
    }

    private var timer = Timer()

    // MARK: - Start and Stop Falling of Tiles
    func startFallingTiles(with interval: TimeInterval) {
        guard !timer.isValid else {
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            self.allTiles.forEach { _ in self.shiftFallingTileDownwards() }
        }
    }

    func pauseFallingTiles() {
        timer.invalidate()
    }

    // MARK: - Adding and Landing Tile Methods
    func setFallingTile(withData data: String, toCoord coordinate: Coordinate) {
        guard !hasFallingTile,
              let view = super.addDetachedTile(withData: data, toCoord: coordinate) else {
            return
        }
        self.fallingTile = view
    }

    func landFallingTile() {
        guard let fallingTile = fallingTile else {
            return
        }
        snapDetachedTile(fallingTile) {
            self.reattachDetachedTile(fallingTile)
            self.fallingTile = nil
            self.onFallingTileLanded?()
        }
    }

    // MARK: - Shifting Falling Tiles
    /// Shifts the tile one step to the left.
    func shiftFallingTileLeftwards() {
        guard let fallingTile = fallingTile else {
            return
        }
        snapDetachedTileLeftwards(fallingTile) {
            self.onFallingTileRepositioned?()
        }
    }

    /// Shifts the tile one step to the right.
    func shiftFallingTileRightwards() {
        guard let fallingTile = fallingTile else {
            return
        }
        snapDetachedTileRightwards(fallingTile) {
            self.onFallingTileRepositioned?()
        }
    }

    /// Shifts the tile one step down.
    func shiftFallingTileDownwards() {
        guard let fallingTile = fallingTile else {
            return
        }
        snapDetachedTileDownwards(fallingTile) {
            self.onFallingTileRepositioned?()
        }
    }
}
