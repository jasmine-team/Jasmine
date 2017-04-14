import UIKit

/// A square grid view controller that builds on the ability to drag a tile and provides
/// functionalities that allows one tile to fall automatically in consistent time interval.
class DiscreteFallableSquareGridViewController: DraggableSquareGridViewController {

    // MARK: - Listeners
    /// Implement this function to get notified when the falling tile has repositioned.
    var onFallingTileRepositioned: (() -> Void)?

    /// Implement this function to get notified when the falling tile has landed.
    var onFallingTileLanded: ((Coordinate) -> Void)?

    // MARK: - Properties
    /// Gets the current falling tiles. Empty implies that no tile is falling currently.
    var fallingTile: SquareTileView?

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

    /// The timer that is used to animate the falling of the tiles.
    private var timer: Timer?

    // MARK: - Start and Stop Falling of Tiles
    /// Starts the timer with the specified interval.
    ///
    /// - Parameter interval: the time interval between each falling tile drop.
    /// - Precondition: timer has not started yet, else results in no-op.
    func startFallingTiles(with interval: TimeInterval) {
        guard timer == nil else {
            return
        }
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            self.shiftFallingTile(towards: .southwards)
        }
    }

    /// Pauses the timer.
    ///
    /// - Precondition: timer has been started (not nil), else results in no-op.
    func pauseFallingTiles() {
        guard let timer = timer else {
            return
        }
        timer.invalidate()
        self.timer = nil
    }

    // MARK: - Adding and Landing Tile Methods
    /// Sets the tile that will fall in this view controller.
    ///
    /// - Parameters:
    ///   - data: the text that is displayed on the falling tile.
    ///   - coordinate: the starting coordinate where the tile will fall.
    /// - Precondition:
    ///   - there is no existing falling tile, else results in no-op.
    ///   - the coordinate is valid (within grid boundary) and is true for 
    ///     `canRepositionDetachedTileToCoord`.
    func setFallingTile(withData data: String, toCoord coordinate: Coordinate) {
        guard !hasFallingTile else {
            return
        }
        self.fallingTile = addDetachedTile(withData: data, toCoord: coordinate)
        guard fallingTile != nil else {
            assertionFailure("A tile has failed to generate at \(coordinate)")
            return
        }
    }

    /// Lands the current falling tile, and attaches it to the grid.
    /// - Precondition: there is a falling tile, else results in no-op.
    func landFallingTile(at coordinate: Coordinate) {
        guard let fallingTile = fallingTile else {
            return
        }
        self.fallingTile = nil
        self.snapDetachedTile(fallingTile, toCoordinate: coordinate) {
            self.reattachDetachedTile(fallingTile, to: coordinate)
            self.onFallingTileLanded?(coordinate)
        }
    }

    // MARK: - Shifting Falling Tiles
    /// Shifts the tile one step to specified direction.
    /// - Parameter direction: the direction where the falling tile should shift to.
    func shiftFallingTile(towards direction: Direction) {
        guard let fallingTile = fallingTile else {
            return
        }
        snapDetachedTile(fallingTile, towards: direction) {
            self.onFallingTileRepositioned?()
        }
    }
}
