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
    /// Caches the database that is used to display onto the collection view in this view controller.
    /// This may not be in sync with the data in the grid.
    fileprivate var gridDataCache: TextGrid!

    /// Conveniently gets the maximum number of rows that should be displayed in this view.
    var numRows: Int {
        return gridDataCache.numRows
    }

    /// Conveniently gets the maximum number of columns that should be displayed in this view.
    var numCols: Int {
        return gridDataCache.numColumns
    }

    /// Specifies the amount of space between each cell.
    fileprivate var cellSpacing: CGFloat = 0

    /// Specifies the custom size of each tile. If nil, implies that a square is desired.
    fileprivate var customSize: CGSize?

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
        allCoordinates.flatMap { getCell(at: $0)?.tiles }
            .forEach { outcome = outcome.union(Set($0)) }
        return outcome
    }

    /// Gets all the tiles directly visible in this collection view.
    var allDisplayedTiles: Set<SquareTileView> {
        let floatingTiles = Set(gridCollectionView.subviews.flatMap { $0 as? SquareTileView })
        let tilesOnGrid = Set(allCoordinates.flatMap { getCell(at: $0)?.displayedTile })
        return floatingTiles.union(tilesOnGrid)
    }

    /// Stores the properties that is used to apply onto all the tiles in that specified coordinate,
    /// that is inside this collection view.
    var tileProperties: [Coordinate: (SquareTileView) -> Void] = [:]

    // MARK: - View Controller Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
        initOtherViewProperties()
    }

    /// Readjusts layout (such as cell size) upon auto-rotate.
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        gridCollectionView.performBatchUpdates(gridCollectionView.reloadData, completion: nil)
    }

    // MARK: - Segue Methods
    /// Load the view controller with initial dataset in this collection view.
    ///
    /// - Parameters:
    ///   - initialGridData: initial set of data to be displayed in this view.
    ///   - space: the space between the tiles in the grid view controller.
    ///   - size: custom size per cell in this view.
    func segueWith(_ initialGridData: TextGrid, withSpace space: CGFloat, customSize: CGSize) {
        self.gridDataCache = initialGridData
        self.cellSpacing = space
    }

    /// Load the view controller with initial dataset in this collection view.
    ///
    /// - Parameters:
    ///   - initialGridData: initial set of data to be displayed in this view.
    ///   - space: the space between the tiles in the grid view controller.
    func segueWith(_ initialGridData: TextGrid, withSpace space: CGFloat) {
        self.gridDataCache = initialGridData
        self.cellSpacing = space
    }

    /// Load the view controller with initial dataset in this collection view, with standard spacing.
    ///
    /// - Parameters:
    ///   - initialGridData: initial set of data to be displayed in this view.
    func segueWith(_ initialGridData: TextGrid) {
        segueWith(initialGridData, withSpace: SquareGridViewController.standardCellSpacing)
    }

    /// Loads the view controller with an empty dataset in this collection view.
    ///
    /// - Parameters:
    ///   - numRow: number of rows to display in this collection view.
    ///   - numCol: number of columns to display in this collection view.
    ///   - space: the space between the tiles in the grid view controller.
    func segueWith(numRow: Int, numCol: Int, withSpace space: CGFloat) {
        segueWith(TextGrid(numRows: numRow, numColumns: numCol), withSpace: space)
    }

    // MARK: - Reload Methods
    /// Reloads the grid with a fresh grid data
    ///
    /// - Parameters:
    ///   - gridData: the grid data to be reloaded with.
    ///   - shouldAnimate: true to reload with a fade animation.
    func reload(gridData: TextGrid, withAnimation shouldAnimate: Bool) {
        self.gridDataCache = gridData
        let indices = allCoordinates.map { $0.toIndexPath }

        UIView.setAnimationsEnabled(shouldAnimate)
        self.gridCollectionView.reloadItems(at: indices)
        UIView.setAnimationsEnabled(true)
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

    /// Get the cell center at the specified coordinate.
    ///
    /// - Parameter coordinate: the coordinate where the view cell's center should be obtained.
    /// - Returns: the center if coordinate is valid.
    func getCenter(from coordinate: Coordinate) -> CGPoint? {
        return getCell(at: coordinate)?.center
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

        squareCell.setOnlyText(gridDataCache[indexPath.toCoordinate])
        squareCell.tileProperties = self.tileProperties[indexPath.toCoordinate]
        return squareCell
    }
}

// MARK: - Collection Cell Sizing
extension SquareGridViewController: UICollectionViewDelegateFlowLayout {

    /// Computes the size of a cell.
    fileprivate var cellSize: CGSize {
        if let customSize = customSize {
            return customSize
        }

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
