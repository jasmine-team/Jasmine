import UIKit

/// A view controller that stores a grid of square cells.
class SquareGridViewController: UIViewController {

    // MARK: Constants
    fileprivate static let cellIdentifier = "Square Text View Cell"

    fileprivate static let snappingDuration = 0.2

    fileprivate static let standardCellSpacing = CGFloat(8.0)

    // MARK: Layouts
    @IBOutlet fileprivate weak var gridCollectionView: UICollectionView!

    // MARK: Properties
    /// Stores the maximum number of rows that should be displayed in this view.
    fileprivate var numRows = 0

    /// Stores the maximum number of columns that should be displayed in this view.
    fileprivate var numCols = 0

    /// Specifies the amount of space between each cell.
    fileprivate var cellSpacing: CGFloat = 0

    /// A lazily computed property that gives all the coordinates that is used in this view.
    fileprivate var allCoordinates: Set<Coordinate> {
        var outcome: Set<Coordinate> = []
        for row in 0..<numRows {
            for col in 0..<numCols {
                outcome.insert(Coordinate(row: row, col: col))
            }
        }
        return outcome
    }

    /// Stores the database that is used to display onto the collection view in this view controller.
    fileprivate var collectionData: [Coordinate: String] = [:]

    /// Stores the set of tiles that are "detached" from the collection view.
    fileprivate var detachedTiles: Set<UIView> = []

    // MARK: View Controller Lifecycles
    /// Readjusts layout (such as cell size) upon auto-rotate.
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        gridCollectionView.performBatchUpdates(gridCollectionView.reloadData, completion: nil)
    }

    // MARK: Segue Methods
    /// Load the view controller with initial dataset, and the number of rows and columns in this
    /// collection view. Note that needing space is assumed.
    ///
    /// - Parameters:
    ///   - initialData: initial set of data to be displayed in this view.
    ///   - numRows: maximum number of rows to be displayed in this grid.
    ///   - numCols: maximum number of columns to be displayed in this grid.
    func segueWith(_ initialData: [Coordinate: String], numRows: Int, numCols: Int) {
        self.segueWith(initialData, numRows: numRows, numCols: numCols, needSpace: true)
    }

    /// Load the view controller with initial dataset, and the number of rows and columns in this
    /// collection view.
    ///
    /// - Parameters:
    ///   - initialData: initial set of data to be displayed in this view.
    ///   - numRows: maximum number of rows to be displayed in this grid.
    ///   - numCols: maximum number of columns to be displayed in this grid.
    ///   - needSpace: when set to true, provides a spacing, else space is removed.
    func segueWith(_ initialData: [Coordinate: String], numRows: Int, numCols: Int, needSpace: Bool) {
        self.collectionData = initialData
        self.numCols = numCols
        self.numRows = numRows
        self.cellSpacing = needSpace ? SquareGridViewController.standardCellSpacing : 0
    }

    // MARK: - Data Interaction
    /// Call this method to update the data stored in this collection view.
    /// However, this does not reload the data in this display.
    ///
    /// - Parameter collectionData: the data source to be updated.
    func update(collectionData: [Coordinate: String]) {
        self.collectionData = collectionData
    }

    /// Call this method to reload the data that is displayed in the collection view with the data
    /// in the data set. However, if the data set is not updated with `update(...)`, no visual
    /// differences will be noted.
    ///
    /// - Parameters:
    ///   - coordinates: the cell coordinates that should be updated.
    ///   - shouldAnimate: true to animate the reloading with fade animation, false otherwise.
    func reload(cellsAt coordinates: Set<Coordinate>, withAnimation shouldAnimate: Bool) {
        let indices = coordinates.map { IndexPath($0) }
        let basicReloadIndices = {
            UIView.setAnimationsEnabled(false)
            self.gridCollectionView.reloadItems(at: indices)
            UIView.setAnimationsEnabled(true)
        }

        if shouldAnimate {
            gridCollectionView.performBatchUpdates(basicReloadIndices, completion: nil)
        } else {
            basicReloadIndices()
        }
    }

    /// Call this method to reload all the data that is displayed in the collection view with the
    /// data in the data set. However, if the data set is not updated with `update(...)`, no visual
    /// differences will be noted.
    ///
    /// - Parameters:
    ///   - shouldAnimate: true to animate the reloading with fade animation, false otherwise.
    func reload(allCellsWithAnimation shouldAnimate: Bool) {
        reload(cellsAt: allCoordinates, withAnimation: shouldAnimate)
    }

    // MARK: - Collection View Properties
    /// Get the coordinate that is under this position in the collection view.
    ///
    /// - Parameter position: position to query with respect to this view controller's coordinate
    ///   system.
    /// - Returns: the underlying coordinate if found, nil otherwise.
    func getCoordinate(at position: CGPoint) -> Coordinate? {
        return gridCollectionView.indexPathForItem(at: position)?.toCoordinate
    }
}

// MARK: - Tile Attachment and Repositioning
extension SquareGridViewController {

    // MARK: Detach Tiles from Collection View
    /// Detach a tile contained in a view cell.
    ///
    /// - Parameter coordinate: the tile that should be detached from the view cell.
    /// - Returns: the detached tile view.
    /// - Note:
    ///   - In these operations, the tile is the underlying view stored inside the view cell.
    ///   - Without detaching the tile, the tile cannot be moved.
    func detachTile(fromCoord coordinate: Coordinate) -> UIView? {
        guard let cell = gridCollectionView.cellForItem(at: IndexPath(coordinate)),
            let squareCell = cell as? SquareTextViewCell,
            let textViewTile = squareCell.textView else {
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
    func addDetachedTile(withData data: String, toFrame frame: CGRect) -> UIView {
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
    func addDetachedTile(withData data: String, toCoord coordinate: Coordinate) -> UIView? {
        guard let targetCell = gridCollectionView.cellForItem(at: IndexPath(coordinate)) else {
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

        gridCollectionView.addSubview(tile)
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
    func moveDetachedTile(_ tile: UIView, toPosition newCenter: CGPoint) {
        guard detachedTiles.contains(tile) else {
            return
        }
        gridCollectionView.bringSubview(toFront: tile)
        tile.center = newCenter
    }

    /// Moves a detached tile in this collection view along the x axis.
    ///
    /// - Parameters:
    ///   - tile: the tile view that should be moved.
    ///   - xCoord: the x coordinate where the tile should be moved to.
    /// - Precondition:
    ///   - This tile has been "detached" from this collection view, otherwise will result in no-op.
    func moveDetachedTile(_ tile: UIView, toAlongXAxis xCoord: CGFloat) {
        guard detachedTiles.contains(tile) else {
            return
        }
        gridCollectionView.bringSubview(toFront: tile)
        tile.center.x = xCoord
    }

    /// Moves a detached tile in this collection view along the y axis.
    ///
    /// - Parameters:
    ///   - tile: the tile view that should be moved.
    ///   - xCoord: the y coordinate where the tile should be moved to.
    /// - Precondition:
    ///   - This tile has been "detached" from this collection view, otherwise will result in no-op.
    func moveDetachedTile(_ tile: UIView, toAlongYAxis yCoord: CGFloat) {
        guard detachedTiles.contains(tile) else {
            return
        }
        gridCollectionView.bringSubview(toFront: tile)
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
    func snapDetachedTile(_ tile: UIView, toCoordinate coordinate: Coordinate,
                          withCompletion callback: (() -> Void)?) {
        guard detachedTiles.contains(tile),
            let targetCell = gridCollectionView.cellForItem(at: IndexPath(coordinate)) else {
                return
        }
        gridCollectionView.bringSubview(toFront: tile)
        UIView.animate(withDuration: SquareGridViewController.snappingDuration,
                       animations: { tile.frame = targetCell.frame },
                       completion: { _ in callback?() })
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
    func snapAndReattachDetachedTile(_ tile: UIView, toCoordinate coordinate: Coordinate,
                                     withCompletion callback: (() -> Void)?) {
        guard detachedTiles.contains(tile),
            let textViewTile = tile as? SquareTextView,
            let destinationCell = gridCollectionView.cellForItem(at: IndexPath(coordinate)),
            let destinationSquareCell = destinationCell as? SquareTextViewCell,
            destinationSquareCell.textView == nil else {
                return
        }

        snapDetachedTile(tile, toCoordinate: coordinate) {
            self.helperAttachTile(for: textViewTile, onto: destinationSquareCell)
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

// MARK: - Tile Falling and Collision
extension SquareGridViewController {

}

// MARK: - Collection View Data Source
extension SquareGridViewController: UICollectionViewDataSource {

    /// Tells the collection view the number of rows to display.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numRows
    }

    /// Tells the collection view the number of cells in a row to display.
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return numCols
    }

    /// Feeds the data to the collection view, and at the same time, save the frame of the 
    /// collection view cell.
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let reusableCell = collectionView
            .dequeueReusableCell(withReuseIdentifier: SquareGridViewController.cellIdentifier,
                                 for: indexPath)

        guard let squareCell = reusableCell as? SquareTextViewCell else {
            fatalError("View Cell that extends from SquareTextViewCell is required.")
        }

        squareCell.text = collectionData[indexPath.toCoordinate]
        return squareCell
    }
}

// MARK: - Collection Cell Sizing
extension SquareGridViewController: UICollectionViewDelegateFlowLayout {

    /// Computes the size of a cell.
    fileprivate var cellSize: CGSize {
        let viewSize = gridCollectionView.bounds.size

        let spacing = cellSpacing
        let numColSpacing = CGFloat(numCols - 1)
        let numRowSpacing = CGFloat(numRows - 1)

        let remainingWidth = viewSize.width - spacing * numColSpacing
        let remainingHeight = viewSize.height - spacing * numRowSpacing

        let maxCellHeight = remainingHeight / CGFloat(numRows)
        let maxCellWidth = remainingWidth / CGFloat(numCols)

        let cellLength = min(maxCellHeight, maxCellWidth)
        return CGSize(width: cellLength, height: cellLength)
    }

    /// Computes the spacing betwen each row.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let insetFromSpacing = cellSpacing / 2.0
        return UIEdgeInsets(top: insetFromSpacing, left: 0, bottom: insetFromSpacing, right: 0)
    }

    /// Computes the spacing between each column.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return cellSpacing
    }

    /// Sets the size of each cell in the collection view to achieve `numRows` x `numCols`.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}
