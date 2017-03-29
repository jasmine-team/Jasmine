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
        return helperAssociateDetachTile(squareTile, withFrame: squareCell.frame)
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

        return helperAssociateDetachTile(squareTile, withFrame: frame)
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
        return addDetachedTile(withData: data, toFrame: targetFrame)
    }

    /// Helper method to perform the actual detachment of the specified tile view.
    ///
    /// - Parameters:
    ///   - tile: the tile to be detached.
    ///   - frame: where the tile should be located after detaching.
    /// - Returns: the detached tile.
    private func helperAssociateDetachTile(
        _ tile: SquareTileView, withFrame frame: CGRect) -> SquareTileView {

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
    func moveDetachedTile(_ tile: SquareTileView, toPosition newCenter: CGPoint) {
        guard detachedTiles.contains(tile) else {
            return
        }
        bringTileToFront(tile)
        tile.center = newCenter
    }

    /// Moves a detached tile in this collection view along the x axis.
    ///
    /// - Parameters:
    ///   - tile: the tile view that should be moved.
    ///   - xCoord: the x coordinate where the tile should be moved to.
    /// - Precondition:
    ///   - This tile has been "detached" from this collection view, otherwise will result in no-op.
    func moveDetachedTile(_ tile: SquareTileView, toAlongXAxis xCoord: CGFloat) {
        guard detachedTiles.contains(tile) else {
            return
        }
        bringTileToFront(tile)
        tile.center.x = xCoord
    }

    /// Moves a detached tile in this collection view along the y axis.
    ///
    /// - Parameters:
    ///   - tile: the tile view that should be moved.
    ///   - xCoord: the y coordinate where the tile should be moved to.
    /// - Precondition:
    ///   - This tile has been "detached" from this collection view, otherwise will result in no-op.
    func moveDetachedTile(_ tile: SquareTileView, toAlongYAxis yCoord: CGFloat) {
        guard detachedTiles.contains(tile) else {
            return
        }
        bringTileToFront(tile)
        tile.center.y = yCoord
    }

    // MARK: Snap And Reattach Tiles to Cells
    /// Animatedly move the detached tile to a particular cell in the specified coordinate.
    ///
    /// - Parameters:
    ///   - tile: tile view to be attached.
    ///   - coordinate: destination coordinate to be attached to.
    ///   - callback: a function that will be called when the tile has successfully been attached.
    /// - Precondition:
    ///   - This tile has been "detached" from this collection view, otherwise will result in no-op.
    /// - Note:
    ///   - This method does not reattach the tile to the specified cell coordinate.
    func snapDetachedTile(_ tile: SquareTileView, toCoordinate coordinate: Coordinate,
                          withCompletion callback: (() -> Void)?) {
        guard detachedTiles.contains(tile),
              let targetFrame = getFrame(at: coordinate) else {
            return
        }
        bringTileToFront(tile)
        UIView.animate(withDuration: DraggableSquareGridViewController.snappingDuration,
                       animations: { tile.frame = targetFrame },
                       completion: { _ in callback?() })
    }

    /// Animatedly move the detached tile to the nearest particular cell, and attached to that cell.
    ///
    /// - Parameters:
    ///   - tile: tile view to be attached.
    /// - Precondition:
    ///   - This tile has been "detached" from this collection view, otherwise will result in no-op.
    func snapAndReattachDetachedTileToNearestCell(_ tile: SquareTileView) {
        guard detachedTiles.contains(tile),
              let targetCoord = getCoordinate(from: tile) else {
            return
        }
        snapAndReattachDetachedTile(tile, toCoordinate: targetCoord, withCompletion: nil)
    }

    /// Reattach the detached tile to a particular cell in the specified coordinate.
    ///
    /// - Parameters:
    ///   - tile: tile view to be attached.
    ///   - coordinate: destination coordinate to be attached to.
    ///   - callback: a function that will be called when the tile has successfully been attached.
    /// - Precondition:
    ///   - This tile has been "detached" from this collection view, otherwise will result in no-op.
    ///   - Multiple attachments to the same cell is allowed.
    func snapAndReattachDetachedTile(_ tile: SquareTileView, toCoordinate coordinate: Coordinate,
                                     withCompletion callback: (() -> Void)?) {
        guard detachedTiles.contains(tile),
              let destinationSquareCell = getCell(at: coordinate) else {
            return
        }

        snapDetachedTile(tile, toCoordinate: coordinate) {
            self.helperAttachTile(for: tile, onto: destinationSquareCell)
            callback?()
        }
    }

    /// Helper method to perform the actual attachment of the specified view.
    ///
    /// - Parameters:
    ///   - tile: the tile to be attached.
    ///   - viewCell: the cell that the tile should be attached to.
    /// - Precondition:
    ///   - Multiple attachments to the same cell is allowed.
    private func helperAttachTile(for tile: SquareTileView, onto viewCell: SquareTileViewCell) {
        tile.removeFromSuperview()
        viewCell.pushTileToTop(tile)
        tile.removeDropShadow()
    }
}
