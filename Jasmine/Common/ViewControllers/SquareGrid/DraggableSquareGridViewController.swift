import UIKit

/// A view controller that stores a grid of square cells with the added feature that the cells can
/// be dragged.
class DraggableSquareGridViewController: SquareGridViewController {

    // MARK: Constants
    private static let snappingDuration = 0.2

    // MARK: Properties
    /// Gets all the tiles in this collection view.
    override var allTiles: Set<SquareTileView> {
        return super.allTiles.union(detachedTiles)
    }

    /// Gets all the tiles displayed in this collection view.
    override var allDisplayedTiles: Set<SquareTileView> {
        return super.allDisplayedTiles.union(detachedTiles)
    }

    /// Stores the set of tiles that are "detached" from the collection view.
    private(set) var detachedTiles: Set<SquareTileView> = []

    // MARK: Event Listeners
    /// Implement a function that checks if the detached tile should be repositioned.
    /// This function takes in a tile and the future coordinate, 
    /// and returns true if the tile can placed there.
    var canRepositionDetachedTileToCoord: ((SquareTileView, Coordinate) -> Bool) = { _ in
        return true
    }

    /// Implement a function that checks if the detached tile should be repositioned.
    /// This function takes in a tile and the future point,
    /// and returns true if the tile can placed there.
    var canRepositionDetachedTileToPosition: ((SquareTileView, CGPoint) -> Bool) = { _ in
        return true
    }

    // MARK: Detach Tiles from Collection View
    /// Detach a tile contained in a view cell.
    ///
    /// - Parameter coordinate: the tile that should be detached from the view cell.
    /// - Returns: the detached tile view.
    /// - Note:
    ///   - In these operations, the tile is the underlying view stored inside the view cell.
    ///   - Without detaching the tile, the tile cannot be moved.
    func detachTile(fromCoord coordinate: Coordinate) -> SquareTileView? {
        guard let squareCell = getCell(at: coordinate),
              let squareTile = squareCell.popTileFromTop() else {
            return nil
        }
        return associateDetachedTile(squareTile, withFrame: squareCell.frame)
    }

    // MARK: Add Detached tiles to Collection View
    /// Add a tile into the collection view stored in the VC. This tile is automatically detached.
    ///
    /// - Parameters:
    ///   - data: the text that is to be displayed on this tile.
    ///   - frame: the new frame to position this tile with reference to this collection view
    ///     coordinates.
    /// - Returns: the tile view.
    /// - Note:
    ///   - In these operations, the tile is the underlying view stored inside the view cell.
    ///   - By detaching the tile, the tile can then be moved.
    func addDetachedTile(withData data: String, toFrame frame: CGRect) -> SquareTileView {
        let squareTile = SquareTileView()
        squareTile.text = data
        return associateDetachedTile(squareTile, withFrame: frame)
    }

    /// Add a tile into the collection view stored in the VC. This tile is automatically detached.
    ///
    /// - Parameters:
    ///   - data: the text that is to be displayed on this tile.
    ///   - coordinate: the coordinate where the tile should lie on.
    /// - Returns: the tile view, if the coordinate is valid. Nil otherwise.
    func addDetachedTile(withData data: String, toCoord coordinate: Coordinate) -> SquareTileView? {
        guard let targetFrame = getFrame(at: coordinate) else {
            return nil
        }
        let tile = SquareTileView()
        tile.text = data
        return associateDetachedTile(tile, withFrame: targetFrame)
    }

    /// Helper method to perform the actual detachment of the specified tile view.
    ///
    /// - Parameters:
    ///   - tile: the tile to be detached.
    ///   - frame: where the tile should be located after detaching.
    /// - Returns: the detached tile.
    /// - Note: this tile will be removed from its superview.
    private func associateDetachedTile(_ tile: SquareTileView,
                                       withFrame frame: CGRect) -> SquareTileView {
        tile.removeFromSuperview()
        tile.frame = frame
        tile.addDropShadow()
        addTileOntoCollectionView(tile)
        detachedTiles.insert(tile)
        return tile
    }

    // MARK: Move Tiles in Collection View
    /// Moves a detached tile in this collection view.
    ///
    /// - Parameters:
    ///   - tile: the tile view that should be moved.
    ///   - newCenter: the new center location to position this tile.
    /// - Precondition:
    ///   - This tile has been "detached" from this collection view, otherwise will result in no-op.
    ///   - Repositioning to the new position is allowed, using `canRepositionDetachedTileToPosition`.
    func moveDetachedTile(_ tile: SquareTileView, toPosition newCenter: CGPoint) {
        guard detachedTiles.contains(tile),
              canRepositionDetachedTileToPosition(tile, newCenter) else {
            return
        }
        bringTileToFront(tile)
        tile.center = newCenter
    }

    /// Moves a detached tile in this collection view along the x axis.
    ///
    /// - Parameters:
    ///   - tile: the tile view that should be moved.
    ///   - xPosition: the x coordinate where the tile should be moved to.
    /// - Precondition:
    ///   - Follows precondition in `moveDetachedTIle(tile, newCenter)`
    func moveDetachedTile(_ tile: SquareTileView, toAlongXAxis xPosition: CGFloat) {
        let newPosition = CGPoint(x: xPosition, y: tile.center.y)
        moveDetachedTile(tile, toPosition: newPosition)
    }

    /// Moves a detached tile in this collection view along the y axis.
    ///
    /// - Parameters:
    ///   - tile: the tile view that should be moved.
    ///   - yPosition: the y coordinate where the tile should be moved to.
    /// - Precondition:
    ///   - Follows precondition in `moveDetachedTIle(tile, newCenter)`
    func moveDetachedTile(_ tile: SquareTileView, toAlongYAxis yPosition: CGFloat) {
        let newPosition = CGPoint(x: tile.center.x, y: yPosition)
        moveDetachedTile(tile, toPosition: newPosition)
    }

    // MARK: Snap Tiles to Cells
    /// Animatedly move the detached tile to a particular cell in the specified coordinate.
    ///
    /// - Parameters:
    ///   - tile: tile view to be snapped.
    ///   - coordinate: destination coordinate to be snapped to.
    ///   - callback: a function that will be called when the tile has successfully been snapped.
    /// - Precondition:
    ///   - This tile has been "detached" from this collection view, otherwise will result in no-op.
    ///   - Repositioning to the new position is allowed, using `canRepositionDetachedTileToCoord`.
    /// - Postcondition:
    ///   - This method does not reattach the tile to the specified cell coordinate.
    func snapDetachedTile(_ tile: SquareTileView, toCoordinate coordinate: Coordinate,
                          withCompletion callback: (() -> Void)?) {
        guard detachedTiles.contains(tile),
              checkCanRepositionTile(tile, toCoord: coordinate),
              let targetFrame = getFrame(at: coordinate) else {
            return
        }
        bringTileToFront(tile)
        UIView.animate(withDuration: DraggableSquareGridViewController.snappingDuration,
                       animations: { tile.frame = targetFrame },
                       completion: { _ in callback?() })
    }

    /// Animatedly move the detached tile to the nearest cell.
    ///
    /// - Parameters:
    ///   - tile: tile view to be snapped.
    ///   - callback: a function that will be called when the tile has successfully been snapped.
    /// - Precondition:
    ///   - Follows precondition in `snapDetachedTile(tile, coordinate, callback)`.
    func snapDetachedTile(_ tile: SquareTileView, withCompletion callback: (() -> Void)?) {
        guard let targetCoord = getCoordinate(from: tile) else {
            return
        }
        snapDetachedTile(tile, toCoordinate: targetCoord, withCompletion: callback)
    }

    /// Animatedly move the detached tile to the neighbouring cell.
    ///
    /// - Parameters:
    ///   - tile: tile view to be snapped.
    ///   - direction: the location neighbouring to the tile in terms of `Direction` enum.
    ///   - callback: a function that will be called when the tile has successfully been snapped.
    /// - Precondition:
    ///   - Follows precondition in `snapDetachedTile(tile, coordinate, callback)`.
    func snapDetachedTile(_ tile: SquareTileView, towards direction: Direction,
                          withCompletion callback: (() -> Void)?) {
        guard let coord = getCoordinate(from: tile) else {
            return
        }
        let destinationCoord: Coordinate
        switch direction {
        case .northwards:
            destinationCoord = coord.prevRow
        case .southwards:
            destinationCoord = coord.nextRow
        case .eastwards:
            destinationCoord = coord.nextCol
        case .westwards:
            destinationCoord = coord.prevCol
        }
        snapDetachedTile(tile, toCoordinate: destinationCoord, withCompletion: callback)
    }

    // MARK: Reattach detached tiles to cell.
    /// Reattaches the tile to a particular cell in the specified coordinate in the collection view.
    ///
    /// - Parameters:
    ///   - tile: tile view to be attached.
    ///   - coordinate: destination coordinate to be attached to.
    /// - Precondition:
    ///   - This tile has been "detached" from this collection view, otherwise will result in no-op.
    ///   - Repositioning to the new position is allowed, using `canRepositionDetachedTileToCoord`.
    /// - Postcondition:
    ///   - This method reattaches the tile to the specified cell coordinate.
    func reattachDetachedTile(_ tile: SquareTileView, to coordinate: Coordinate) {
        guard detachedTiles.contains(tile),
              checkCanRepositionTile(tile, toCoord: coordinate),
              let destinationCell = getCell(at: coordinate) else {
            return
        }
        detachedTiles.remove(tile)
        tile.removeFromSuperview()
        destinationCell.pushTileToTop(tile)
        tile.removeDropShadow()
    }

    /// Reattaches the tile to the nearest particular cell in the specified coordinate in the 
    /// collection view.
    ///
    /// - Parameters:
    ///   - tile: tile view to be attached.
    ///   - coordinate: destination coordinate to be attached to.
    /// - Precondition:
    ///   - Follows precondition in `reattachDetachedTile(tile, coordinate)`.
    /// - Postcondition:
    ///   - Follows postcondition in `reattachDetachedTile(tile, coordinate)`.
    func reattachDetachedTile(_ tile: SquareTileView) {
        guard let destinationCoord = getCoordinate(at: tile.center) else {
            return
        }
        reattachDetachedTile(tile, to: destinationCoord)
    }

    // MARK: - Helper Methods
    /// Checks if the new coordinate is valid by asking the delegate, and checking the coordinate
    /// bounds.
    private func checkCanRepositionTile(_ tile: SquareTileView, toCoord newCoord: Coordinate) -> Bool {
        return newCoord.isWithin(numRows: numRows, numCols: numCols)
            && canRepositionDetachedTileToCoord(tile, newCoord)
    }
}
