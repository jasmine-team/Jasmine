import UIKit

/// Manages the Tetris grid view
class TetrisGridView {

    private let collectionView: UICollectionView

    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
    }

    private func getIndexPath(_ coordinate: Coordinate) -> IndexPath {
        return IndexPath(row: coordinate.col, section: coordinate.row)
    }

    private func getCell(at indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            fatalError("Failed to get cell at \(indexPath)")
        }
        return cell
    }

    private func getSubview(at indexPath: IndexPath) -> UIView {
        guard let subview = getCell(at: indexPath).contentView.subviews.last else {
            fatalError("Failed to get subview")
        }
        return subview
    }

    /// Adds a new view to the cell at indexPath
    func addToCell(_ view: UIView, at coordinate: Coordinate) {
        getCell(at: getIndexPath(coordinate)).contentView.addSubview(view)
    }

    /// Removes the view in the cell at indexPath
    func clearCell(at coordinate: Coordinate) {
        getSubview(at: getIndexPath(coordinate)).removeFromSuperview()
    }

    /// Shifts the view to the cell one row below it
    func shiftViewDown(at coordinate: Coordinate) {
        let sourceView = getSubview(at: getIndexPath(coordinate))
        sourceView.removeFromSuperview()
        addToCell(sourceView, at: Coordinate(row: coordinate.row + 1, col: coordinate.col))
    }
}
