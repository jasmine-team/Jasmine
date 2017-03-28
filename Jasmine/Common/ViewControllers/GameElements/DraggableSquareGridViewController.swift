import UIKit

/// A view controller that stores a grid of square cells with the added feature that the cells can
/// be dragged.
class DraggableSquareGridViewController: SquareGridViewController {

    // MARK: Constants
    private static let snappingDuration = 0.2

    // MARK: Properties
    /// Gets all the tiles in this collection view.
    override var allTiles: Set<SquareTextView> {
        return super.allTiles.union(detachedTiles)
    }

    /// Stores the set of tiles that are "detached" from the collection view.
    private(set) var detachedTiles: Set<SquareTextView> = []

    // MARK: Detach Tiles from Collection View
    /// Detach a tile contained in a view cell.
    ///
    /// - Parameter coordinate: the tile that should be detached from the view cell.
    /// - Returns: the detached tile view.
    /// - Note:
    ///   - In these operations, the tile is the underlying view stored inside the view cell.
    ///   - Without detaching the tile, the tile cannot be moved.
    func detachTile(fromCoord coordinate: Coordinate) -> SquareTextView? {
        guard let squareCell = getCell(at: coordinate),
            let textViewTile = getTile(at: coordinate) else {
                return nil
        }
        return helperDetachTile(for: textViewTile, withFrame: squareCell.frame)
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
    func addDetachedTile(withData data: String, toFrame frame: CGRect) -> SquareTextView {
        let squareTile = SquareTextView()
        squareTile.text = data

        return helperDetachTile(for: squareTile, withFrame: frame)
    }

    /// Add a tile into the collection view stored in the VC. This tile is automatically detached.
    ///
    /// - Parameters:
    ///   - data: the text that is to be displayed on this tile.
    ///   - coordinate: the coordinate where the tile should lie on.
    /// - Returns: the tile view, if the coordinate is valid. Nil otherwise.
    func addDetachedTile(withData data: String, toCoord coordinate: Coordinate) -> SquareTextView? {
        guard let targetCell = getCell(at: coordinate) else {
            return nil
        }
        return addDetachedTile(withData: data, toFrame: targetCell.frame)
    }

    /// Helper method to perform the actual detachment of the specified tile view.
    ///
    /// - Parameters:
    ///   - tile: the tile to be detached.
    ///   - frame: where the tile should be located after detaching.
    /// - Returns: the detached tile.
    private func helperDetachTile(for tile: SquareTextView, withFrame frame: CGRect) -> SquareTextView {
        tile.frame = frame
        tile.addDropShadow()
        tile.removeFromSuperview()

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
    func moveDetachedTile(_ tile: SquareTextView, toPosition newCenter: CGPoint) {
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
    func moveDetachedTile(_ tile: SquareTextView, toAlongXAxis xCoord: CGFloat) {
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
    func moveDetachedTile(_ tile: SquareTextView, toAlongYAxis yCoord: CGFloat) {
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
    func snapDetachedTile(_ tile: SquareTextView, toCoordinate coordinate: Coordinate,
                          withCompletion callback: (() -> Void)?) {
        guard detachedTiles.contains(tile),
              let targetCell = getCell(at: coordinate) else {
            return
        }
        bringTileToFront(tile)
        UIView.animate(withDuration: DraggableSquareGridViewController.snappingDuration,
                       animations: { tile.frame = targetCell.frame },
                       completion: { _ in callback?() })
    }

    /// Animatedly move the detached tile to the nearest particular cell.
    ///
    /// - Parameters:
    ///   - tile: tile view to be attached.
    /// - Precondition:
    ///   - This tile has been "detached" from this collection view, otherwise will result in no-op.
    /// - Note:
    ///   - This method does not reattach the tile to the specified cell coordinate.
    func snapDetachedTileToNearestCell(_ tile: SquareTextView) {
        guard detachedTiles.contains(tile),
              let targetCoord = getCoordinate(at: tile.center) else {
            return
        }
        snapDetachedTile(tile, toCoordinate: targetCoord, withCompletion: nil)
    }

    /// Reattach the detached tile to a particular cell in the specified coordinate.
    ///
    /// - Parameters:
    ///   - tile: tile view to be attached.
    ///   - coordinate: destination coordinate to be attached to.
    ///   - callback: a function that will be called when the tile has successfully been attached.
    /// - Precondition:
    ///   - This tile has been "detached" from this collection view, otherwise will result in no-op.
    ///   - The destinating cell does not contain any other tile. Otherwise results in no-op.
    func snapAndReattachDetachedTile(_ tile: SquareTextView, toCoordinate coordinate: Coordinate,
                                     withCompletion callback: (() -> Void)?) {
        guard detachedTiles.contains(tile),
            let destinationSquareCell = getCell(at: coordinate),
            destinationSquareCell.textView == nil else {
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
    ///   - The destinating cell does not contain any other tile. Otherwise results in no-op.
    private func helperAttachTile(for tile: SquareTextView, onto viewCell: SquareTextViewCell) {
        guard viewCell.textView == nil else {
            return
        }
        tile.removeFromSuperview()
        viewCell.textView = tile
        tile.removeDropShadow()
    }
}
