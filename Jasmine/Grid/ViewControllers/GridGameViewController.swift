import UIKit

/// View Controller implementation for Grid Game.
/// - Author: Wang Xien Dong
class GridGameViewController: UIViewController {

    // MARK: Layouts
    fileprivate var squareGridViewController: SquareGridViewController!

    fileprivate var draggingTile: (view: UIView, originalCoord: Coordinate)?

    // MARK: Game Properties
    fileprivate var gameEngine: GridGameEngineProtocol!

    // MARK: View Controller Lifecycles
    /// Specifies that the supported orientation for this view is portrait only.
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // MARK: Segue methods
    /// Method that manages the seguing to other view controllers from this view controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let squareGridView = segue.destination as? SquareGridViewController {
            squareGridView.segueWith(gameEngine.gridData,
                                     numRows: Constants.BoardGamePlay.rows,
                                     numCols: Constants.BoardGamePlay.columns)
            self.squareGridViewController = squareGridView
        }
    }

    /// Feeds in the appropriate data for the use of seguing into this view.
    ///
    /// - Parameter gameEngine: the game engine required to play this game.
    func segueWith(_ gameEngine: GridGameEngineProtocol) {
        self.gameEngine = gameEngine
        self.gameEngine.delegate = self
    }

    // MARK: Gesture Recognisers
    /// Listens to a drag gesture and handles the operation of dragging a tile, and dropping it
    /// to another location.
    @IBAction func onTilesDragged(_ sender: UIPanGestureRecognizer) {
        let position = sender.location(in: squareGridViewController.view)

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
        guard
            draggingTile == nil,
            let coordTouched = squareGridViewController.getCoordinate(at: position),
            let detachedCell = squareGridViewController.detachTile(fromCoord: coordTouched) else {
                return
        }
        draggingTile = (detachedCell, coordTouched)
    }

    /// Drags the tile that is referenced in `draggingTile`.
    ///
    /// - Parameter position: location where the tile should drag to.
    fileprivate func handleTileDragged(at position: CGPoint) {
        guard let draggingTile = draggingTile else {
            return
        }
        squareGridViewController.moveDetachedTile(draggingTile.view, toPosition: position)
    }

    /// Lands the tile at the specified position, if such a cell is found.
    /// The other cell will snap to the dragged cell position.
    /// If fails to find a place, the dragged cell shall return to original position.
    ///
    /// - Parameter position: location where the tile should land.
    fileprivate func handleTileLanding(at position: CGPoint) {
        guard let draggingTile = draggingTile else {
            return
        }
        guard
            let landedCoord = squareGridViewController.getCoordinate(at: position),
            gameEngine.swapTiles(draggingTile.originalCoord, and: landedCoord) else {
                handleTileFailedLanding()
                return
        }
        handleTileSuccessfulLanding(on: landedCoord)
    }

    /// Helper method to let the dragged tile to return to its original position.
    private func handleTileFailedLanding() {
        guard let tile = draggingTile else {
            return
        }
        squareGridViewController.snapDetachedTile(tile.view, toCoordinate: tile.originalCoord) {
            self.draggingTile = nil
        }
    }

    /// Helper method to switch the landed tile and vacated tile, and update the database at the
    /// same time.
    private func handleTileSuccessfulLanding(on landedCoord: Coordinate) {
        guard let draggingTile = draggingTile else {
            return
        }
        guard let landedView = squareGridViewController.detachTile(fromCoord: landedCoord) else {
            handleTileFailedLanding()
            return
        }

        self.draggingTile = nil
        let startingView = draggingTile.view
        let startingCoord = draggingTile.originalCoord
        let endingView = landedView
        let endingCoord = landedCoord

        squareGridViewController.snapDetachedTile(startingView, toCoordinate: endingCoord) {
            self.squareGridViewController.reload(cellsAt: [endingCoord], withAnimation: false)
        }
        self.squareGridViewController.snapDetachedTile(endingView, toCoordinate: startingCoord) {
            self.squareGridViewController.reload(cellsAt: [startingCoord], withAnimation: false)

        }
    }
}

// MARK: - Delegate for Grid Game
extension GridGameViewController: GridGameViewControllerDelegate {

    /// Update the grid data stored in the Grid Game View Controller with a new dataset.
    func update(tilesWith newGridData: [Coordinate: String]) {
        squareGridViewController.update(collectionData: newGridData)
    }

    /// Refreshes the tiles based on the tiles information stored in the View Controller's grid data.
    func redisplayAllTiles() {
        squareGridViewController.reload(allCellsWithAnimation: true)
    }

    /// Refreshes a selected set of tiles based on the tiles information stored in the VC's grid data.
    func redisplay(tilesAt coordinates: Set<Coordinate>) {
        squareGridViewController.reload(cellsAt: coordinates, withAnimation: true)
    }

    /// Refreshes one particular tile based on the tiles information stored in the VC's grid data.
    func redisplay(tileAt coordinate: Coordinate) {
        squareGridViewController.reload(cellsAt: [coordinate], withAnimation: true)
    }
}

extension GridGameViewController: BaseGameViewControllerDelegate {
    // MARK: Score Update
    /// Redisplay the score displayed on the view controller screen with a new score.
    func redisplay(newScore: Int) {

    }

    // MARK: Time Update
    /// Redisplay the time remaining on the view controller against a total time.
    func redisplay(remainingTime: TimeInterval, outOf totalTime: TimeInterval) {

    }

    // MARK: Game Status
    /// Notifies the view controller that the game state has changed.
    func notifyGameStatus(with newStatus: GameStatus) {

    }
}
