import UIKit

/// A view controller that stores a grid of square cells.
class SquareGridViewController: UIViewController {

    // MARK: Constants
    fileprivate static let cellIdentifier = "Square Text View Cell"

    // MARK: Layouts
    @IBOutlet fileprivate weak var gridCollectionView: UICollectionView!

    // MARK: Properties
    fileprivate var numRows = 0
    fileprivate var numCols = 0

    /// Stores the collection data to be displayed in this view.
    fileprivate var collectionData: [Coordinate: String] = [:]

    // MARK: View Controller Lifecycles
    /// Readjusts layout (such as cell size) upon auto-rotate.
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        gridCollectionView.performBatchUpdates(gridCollectionView.reloadData, completion: nil)
    }

    // MARK: Segue Methods
    /// Load the view controller with initial dataset, and the number of rows and columns in this
    /// collection view.
    ///
    /// - Parameters:
    ///   - initialData: initial set of data to be displayed in this view.
    ///   - numRows: maximum number of rows to be displayed in this grid.
    ///   - numCols: maximum number of columns to be displayed in this grid.
    func segueWith(_ initialData: [Coordinate: String], numRows: Int, numCols: Int) {
        self.collectionData = initialData
        self.numCols = numCols
        self.numRows = numRows
    }

    // MARK: Data Interaction
    /// Call this method to update the data stored in this collection view.
    /// However, this does not reload the data in this display.
    ///
    /// - Parameter collectionData: the data source to be updated.
    func update(collectionData: [Coordinate: String]) {
        self.collectionData = collectionData
    }

    // MARK: Collection View Reloading
    /// Call this method to reload the data that is displayed in the collection view with the data
    /// in the data set. However, if the data set is not updated with `update(...)`, no visual
    /// differences will be noted.
    ///
    /// - Parameters:
    ///   - coordinates: the cell coordinates that should be updated.
    ///   - shouldAnimate: true to animate the reloading with fade animation, false otherwise.
    func reload(cellsAt coordinates: Set<Coordinate>, withAnimation shouldAnimate: Bool) {
        let indices = coordinates.map { IndexPath($0) }
        let basicReloadIndices = { self.gridCollectionView.reloadItems(at: indices) }

        if shouldAnimate {
            gridCollectionView.performBatchUpdates(basicReloadIndices, completion: nil)
        } else {
            basicReloadIndices()
        }
    }
}

// MARK: - Collection View Data Source
extension SquareGridViewController: UICollectionViewDataSource {

    /// Tells the charactersCollectionView the number of rows to display.
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numRows
    }

    /// Tells the charactersCollectionView the number of cells in a row to display.
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return numCols
    }

    /// Feeds the data (chinese characters) to the charactersCollectionView.
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let reusableCell = collectionView
            .dequeueReusableCell(withReuseIdentifier: SquareGridViewController.cellIdentifier,
                                 for: indexPath)

        guard let squareCell = reusableCell as? SquareTextViewCell else {
            fatalError("View Cell that extends from ChineseCharacterViewCell is required.")
        }
        squareCell.text = collectionData[indexPath.toCoordinate]
        return squareCell
    }
}

// MARK: - Collection Cell Sizing
extension SquareGridViewController: UICollectionViewDelegateFlowLayout {

    /// Sets the size of each cell in the collection view to achieve `numRows` x `numCols`.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let viewSize = gridCollectionView.bounds.size
        let maxCellHeight = viewSize.height / CGFloat(numRows)
        let maxCellWidth = viewSize.height / CGFloat(numCols)

        let cellLength = min(maxCellHeight, maxCellWidth)
        return CGSize(width: cellLength, height: cellLength)
    }
}
