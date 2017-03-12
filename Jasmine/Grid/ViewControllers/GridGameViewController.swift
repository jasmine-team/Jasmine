import UIKit

/// View Controller implementation for Grid Game.
/// - Author: Wang Xien Dong
class GridGameViewController: UIViewController {

    /* Constants */
    fileprivate static let characterCellIdentifier = "Grid Game Character Cell"

    /// Provides a tolerance (via a factor of the expected size) so that 4 cells can fit in one row.
    fileprivate static let cellSizeFactor = CGFloat(0.9)

    /* Layouts */
    /// Keeps a 4 x 4 of chinese characters as individual cells.
    @IBOutlet fileprivate weak var charactersCollectionView: UICollectionView!

    /* Properties */
    /// Stores a list of Chinese characters, which serves as the data source for  
    /// `charactersCollectionView`.
    fileprivate var chineseTexts: [String?]
        = ["天", "翻", "地", "覆", nil, nil, nil, nil, "天", "翻", "地", "覆", nil, nil, nil, nil]

    fileprivate var draggingTile: SquareTextViewCell?
    fileprivate var draggingStartFrame: CGRect?

    /* View Controller Lifecycles */
    /// Readjusts layout (such as cell size) upon auto-rotate.
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        charactersCollectionView.performBatchUpdates(charactersCollectionView.reloadData,
                                                     completion: nil)
    }

    /* Gesture Recognisers */
    /// Listens to a drag gesture and handles the operation of dragging a tile, and dropping it
    /// to another location.
    @IBAction func onTilesDragged(_ sender: UIPanGestureRecognizer) {
        let position = sender.location(in: charactersCollectionView)

        switch sender.state {
        case .began:
            handleTileSelected(at: position)

        case .changed:
            handleTileDragged(at: position)

        case .ended:
            handleTileDropped(at: position)

        default:
            break
        }
    }
}

// MARK: - Drag and Drop Tiles
fileprivate extension GridGameViewController {

    fileprivate func handleTileSelected(at position: CGPoint) {
        guard draggingTile == nil else {
            return
        }
        guard draggingStartFrame == nil else {
            return
        }
        guard let indexTouched = charactersCollectionView.indexPathForItem(at: position) else {
            return
        }
        guard let cellTouched = charactersCollectionView
            .cellForItem(at: indexTouched) as? SquareTextViewCell else {
                return
        }

        draggingTile = cellTouched
        draggingStartFrame = cellTouched.frame
    }

    fileprivate func handleTileDragged(at position: CGPoint) {
        draggingTile?.frame.origin = position
    }

    fileprivate func handleTileDropped(at position: CGPoint) {
        guard let draggingTile = draggingTile else {
            return
        }
        guard let draggingStartFrame = draggingStartFrame else {
            return
        }
        guard let indexLanded = charactersCollectionView.indexPathForItem(at: position) else {
            return
        }
        guard let cellToVacate = charactersCollectionView
            .cellForItem(at: indexLanded) as? SquareTextViewCell else {
                return
        }

        UIView.animate(withDuration: 1.0, animations: {
            draggingTile.frame = cellToVacate.frame
            cellToVacate.frame = draggingStartFrame
        }, completion: { _ in
            self.draggingTile = nil
            self.draggingStartFrame = nil
        })
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
        let length = charactersCollectionView.bounds.width / CGFloat(Constants.BoardGamePlay.columns)
            * GridGameViewController.cellSizeFactor

        return CGSize(width: length, height: length)
    }
}
