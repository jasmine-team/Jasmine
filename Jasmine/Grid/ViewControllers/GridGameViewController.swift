import UIKit

/// View Controller implementation for Grid Game.
/// - Author: Wang Xien Dong
class GridGameViewController: UIViewController {

    /* Constants */
    fileprivate static let characterCellIdentifier = "Grid Game Character Cell"
    fileprivate static let snappingDuration = 0.3

    /// Provides a tolerance (via a factor of the expected size) so that 4 cells can fit in one row.
    fileprivate static let cellSizeFactor = CGFloat(0.9)

    /* Layouts */
    /// Keeps a 4 x 4 of chinese characters as individual cells.
    @IBOutlet fileprivate weak var gridCollectionView: UICollectionView!

    /* Properties */
    /// Stores a list of Chinese characters, which serves as the data source for  
    /// `charactersCollectionView`.
    fileprivate var chineseTexts: [String?]
        = ["天", "翻", "地", "覆",
           "CS32", "17", ":D", ":(",
           "天", "翻", "地", "覆",
           nil, "😛", nil, "😉"]

    fileprivate var draggingTile: SquareTextViewCell?
    fileprivate var draggingStartFrame: CGRect?
    fileprivate var draggingStartIndex: IndexPath?

    /* View Controller Lifecycles */
    /// Readjusts layout (such as cell size) upon auto-rotate.
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        gridCollectionView.performBatchUpdates(gridCollectionView.reloadData, completion: nil)
    }

    /* Gesture Recognisers */
    /// Listens to a drag gesture and handles the operation of dragging a tile, and dropping it
    /// to another location.
    @IBAction func onTilesDragged(_ sender: UIPanGestureRecognizer) {
        let position = sender.location(in: gridCollectionView)

        switch sender.state {
        case .began:
            handleTileSelected(at: position)

        case .changed:
            handleTileDragged(at: position)

        case .ended:
            handleTileLanding(at: position)

        default:
            break
        }
    }
}

// MARK: - Drag and Drop Tiles
fileprivate extension GridGameViewController {

    /// Handles the case when the tile is lifted from the collection view.
    /// Such a tile gets "detached" from the view by having its identity noted down in the 
    /// properties.
    ///
    /// - Parameter position: location where the tile is selected.
    fileprivate func handleTileSelected(at position: CGPoint) {
        guard draggingTile == nil,
            draggingStartFrame == nil,
            let indexTouched = gridCollectionView.indexPathForItem(at: position),
            let cellTouched = gridCollectionView.cellForItem(at: indexTouched),
            let squareCellTouched = cellTouched as? SquareTextViewCell else {
                return
        }

        gridCollectionView.bringSubview(toFront: squareCellTouched)
        draggingTile = squareCellTouched
        draggingStartFrame = cellTouched.frame
        draggingStartIndex = indexTouched
    }

    /// Drags the tile that is referenced in `draggingTile`.
    ///
    /// - Parameter position: location where the tile should drag to.
    fileprivate func handleTileDragged(at position: CGPoint) {
        guard let draggingTile = draggingTile else {
            return
        }
        let size = draggingTile.frame.size
        let newOrigin = GeometryUtils.getOrigin(from: position, withSize: size)
        draggingTile.frame.origin = newOrigin
    }

    /// Lands the tile at the specified position, if such a cell is found.
    /// The other cell will snap to the dragged cell position.
    /// If fails to find a place, the dragged cell shall return to original position.
    ///
    /// - Parameter position: location where the tile should land.
    fileprivate func handleTileLanding(at position: CGPoint) {
        guard let indexLanded = gridCollectionView.indexPathForItem(at: position),
            let cellToVacate = gridCollectionView.cellForItem(at: indexLanded),
            let squareCellToVacate = cellToVacate as? SquareTextViewCell else {

                handleTileFailedLanding()
                return
        }

        handleTileSuccessfulLanding(on: squareCellToVacate, at: indexLanded)
    }

    /// Helper method to let the dragged tile to return to its original position.
    private func handleTileFailedLanding() {
        guard let draggingTile = draggingTile,
            let draggingStartFrame = draggingStartFrame else {
                return
        }

        let animation: () -> Void = {
            draggingTile.frame = draggingStartFrame
        }

        let completion: (Bool) -> Void = { _ in
            self.draggingTile = nil
            self.draggingStartFrame = nil
        }

        UIView.animate(withDuration: GridGameViewController.snappingDuration,
                       animations: animation,
                       completion: completion)
    }

    /// Helper method to switch the landed tile and vacated tile, and update the database at the
    /// same time.
    private func handleTileSuccessfulLanding(on otherCell: SquareTextViewCell,
                                             at otherIndex: IndexPath) {
        guard let draggingTile = draggingTile,
            let draggingStartFrame = draggingStartFrame,
            let draggingStartIndex = draggingStartIndex else {
                return
        }

        swap(&chineseTexts[otherIndex.item], &chineseTexts[draggingStartIndex.item])

        let animation: () -> Void = {
            draggingTile.frame = otherCell.frame
            otherCell.frame = draggingStartFrame
        }

        let completion: (Bool) -> Void = { _ in
            UIView.setAnimationsEnabled(false)
            otherCell.frame = draggingTile.frame
            draggingTile.frame = draggingStartFrame
            self.gridCollectionView.reloadItems(at: [draggingStartIndex, otherIndex])
            UIView.setAnimationsEnabled(true)

            self.draggingTile = nil
            self.draggingStartFrame = nil
            self.draggingStartIndex = nil
        }

        UIView.animate(withDuration: GridGameViewController.snappingDuration,
                       animations: animation,
                       completion: completion)
    }
}

// MARK: - Data Source for Characters Collection View
extension GridGameViewController: UICollectionViewDataSource {

    /// Tells the charactersCollectionView the number of cells to display.
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return chineseTexts.count
    }

    /// Feeds the data (chinese characters) to the charactersCollectionView.
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let reusableCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GridGameViewController.characterCellIdentifier, for: indexPath)

        guard let textCell = reusableCell as? SquareTextViewCell else {
            fatalError("View Cell that extends from ChineseCharacterViewCell is required.")
        }
        textCell.text = chineseTexts[indexPath.item]
        return textCell
    }
}

// MARK: - Size of each Character View Cell
extension GridGameViewController: UICollectionViewDelegateFlowLayout {

    /// Sets the size of each cell in charactersCollectionView such that we have a 4x4 grid.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = gridCollectionView.bounds.width / CGFloat(Constants.BoardGamePlay.columns)
                * GridGameViewController.cellSizeFactor

        return CGSize(width: length, height: length)
    }
}
