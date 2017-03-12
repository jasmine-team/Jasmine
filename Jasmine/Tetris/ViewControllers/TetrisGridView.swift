import UIKit

/// Manages the Tetris grid view

class TetrisGridView {

    private let collectionView: UICollectionView

    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
    }

    /// Adds a new view to the cell at indexPath
    func addToCell(_ view: UIView, at indexPath: IndexPath) {
        getCell(at: indexPath).contentView.addSubview(view)
    }

    /// Removes the view in the cell at indexPath
    func clearCell(at indexPath: IndexPath) {
        getSubview(at: indexPath).removeFromSuperview()
    }

    /// Shifts the view to the cell one row below it
    func shiftViewDown(at indexPath: IndexPath) {
        let sourceView = getSubview(at: indexPath)
        sourceView.removeFromSuperview()
        addToCell(sourceView, at: IndexPath(row: indexPath.row, section: indexPath.section + 1))
    }

    private func getCell(at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            assert(false, "Failed to get cell")
        }
        return cell
    }

    private func getSubview(at indexPath: IndexPath) -> UIView {
        guard let subview = getCell(at: indexPath).contentView.subviews.last else {
            assert(false, "Failed to get subview")
        }
        return subview
    }
}
