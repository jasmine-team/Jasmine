import UIKit
import SnapKit

/// A view controller that stores a grid of square cells.
class SquareGridViewController: UIViewController {

    // MARK: Constants
    fileprivate static let cellIdentifier = "Square Text View Cell"

    fileprivate static let standardCellSpacing = CGFloat(8.0)

    // MARK: Layouts
    fileprivate let gridCollectionView
        = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    // MARK: Properties
    /// Stores the maximum number of rows that should be displayed in this view.
    private(set) var numRows = 0

    /// Stores the maximum number of columns that should be displayed in this view.
    private(set) var numCols = 0

    /// Specifies the amount of space between each cell.
    fileprivate var cellSpacing: CGFloat = 0

    /// A lazily computed property that gives all the coordinates that is used in this view.
    var allCoordinates: Set<Coordinate> {
        var outcome: Set<Coordinate> = []
        for row in 0..<numRows {
            for col in 0..<numCols {
                outcome.insert(Coordinate(row: row, col: col))
            }
        }
        return outcome
    }

    /// Gets all the tiles in this collection view.
    var allTiles: Set<SquareTileView> {
        var outcome = Set(gridCollectionView.subviews.flatMap { $0 as? SquareTileView })
        for tiles in allCoordinates.flatMap({ getCell(at: $0)?.tiles }) {
            outcome = outcome.union(Set(tiles))
        }
        return outcome
    }

    /// Gets all the tiles directly visible in this collection view.
    var allDisplayedTiles: Set<SquareTileView> {
        let floatingTiles = Set(gridCollectionView.subviews.flatMap { $0 as? SquareTileView })
        let tilesOnGrid = Set(allCoordinates.flatMap { getCell(at: $0)?.displayedTile })
        return floatingTiles.union(tilesOnGrid)
    }

    /// Stores the database that is used to display onto the collection view in this view controller.
    fileprivate var collectionData: [Coordinate: String] = [:]

    // MARK: View Controller Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
        initOtherViewProperties()
    }

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
        self.segueWith(initialData, numRows: numRows, numCols: numCols,
                       withSpace: SquareGridViewController.standardCellSpacing)
    }

    /// Load the view controller with initial dataset, and the number of rows and columns in this
    /// collection view.
    ///
    /// - Parameters:
    ///   - initialData: initial set of data to be displayed in this view.
    ///   - numRows: maximum number of rows to be displayed in this grid.
    ///   - numCols: maximum number of columns to be displayed in this grid.
    ///   - needSpace: when set to true, provides a spacing, else space is removed.
    func segueWith(_ initialData: [Coordinate: String], numRows: Int, numCols: Int,
                   withSpace space: CGFloat) {

        self.collectionData = initialData
        self.numCols = numCols
        self.numRows = numRows
        self.cellSpacing = space
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
        let indices = coordinates.map { $0.toIndexPath }
        let basicReloadIndices = {
            self.gridCollectionView.reloadItems(at: indices)
        }

        if shouldAnimate {
            gridCollectionView.performBatchUpdates(basicReloadIndices, completion: nil)
        } else {
            UIView.setAnimationsEnabled(false)
            basicReloadIndices()
            UIView.setAnimationsEnabled(true)
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

    /// Get the coordinate of where this tile is.
    ///
    /// - Parameter tile: the tile where the coordinate should be queried.
    /// - Returns: the underlying coordinate if found, nil otherwise.
    func getCoordinate(from tile: SquareTileView) -> Coordinate? {
        return getCoordinate(at: tile.center)
    }

    /// Get the cell at the specified coordinate.
    ///
    /// - Parameter coordinate: the coordinate where the view cell should be obtained.
    /// - Returns: the view cell with the class SquareTileViewCell.
    func getCell(at coordinate: Coordinate) -> SquareTileViewCell? {
        return gridCollectionView.cellForItem(at: coordinate.toIndexPath) as? SquareTileViewCell
    }

    /// Get the cell frame at the specified coordinate.
    ///
    /// - Parameter coordinate: the coordinate where the view cell frame should be obtained.
    /// - Returns: the frame if coordinate is valid.
    func getFrame(at coordinate: Coordinate) -> CGRect? {
        return getCell(at: coordinate)?.frame
    }

    /// Adds the specified tile to the collection view.
    ///
    /// - Parameter tile: the tile to be added right on the collection view.
    func addTileOntoCollectionView(_ tile: SquareTileView) {
        gridCollectionView.addSubview(tile)
    }

    /// Brings the tile to the front of the view.
    ///
    /// - Parameter tile: the tile to be brought to the front.
    func bringTileToFront(_ tile: SquareTileView) {
        gridCollectionView.bringSubview(toFront: tile)
    }

    // MARK: Helper Methods
    private func initCollectionView() {
        gridCollectionView.delegate = self
        gridCollectionView.dataSource = self
        gridCollectionView.isScrollEnabled = false
        gridCollectionView.clipsToBounds = false
        gridCollectionView.backgroundColor = UIColor.clear
        gridCollectionView.register(
            SquareTileViewCell.self,
            forCellWithReuseIdentifier: SquareGridViewController.cellIdentifier)

        view.addSubview(gridCollectionView)
        gridCollectionView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    private func initOtherViewProperties() {
        view.clipsToBounds = false
    }
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

        guard let squareCell = reusableCell as? SquareTileViewCell else {
            fatalError("View Cell that extends from SquareTileViewCell is required.")
        }

        squareCell.setOnlyText(collectionData[indexPath.toCoordinate])
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

    /// Computes the sum of left and right margin width.
    private var totalMarginWidth: CGFloat {
        let gridWidth = gridCollectionView.bounds.width
        let cellWidth = cellSize.width
        return gridWidth - (cellWidth + cellSpacing) * CGFloat(numCols)
    }

    /// Computes the spacing betwen each row.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let insetFromSpacing = cellSpacing / 2.0
        let margin = totalMarginWidth / 2.0
        return UIEdgeInsets(top: insetFromSpacing, left: margin,
                            bottom: insetFromSpacing, right: margin)
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
