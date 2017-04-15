import UIKit

/// View Controller implementation for Swapping Game.
class SwappingGameViewController: BaseGridGameViewController {

    // MARK: - Constants
    fileprivate static let segueToGameOverView = "SegueToGameOverViewController"

    fileprivate static let segueDelay = 0.5

    fileprivate static let highlightDelay = 0.3

    // MARK: Layouts
    fileprivate var squareGridViewController: DraggableSquareGridViewController!

    @IBOutlet private weak var navigationBar: UINavigationBar!

    fileprivate var draggingTile: (view: SquareTileView, originalCoord: Coordinate)?

    // MARK: Game Properties
    fileprivate var viewModel: SwappingViewModelProtocol!

    // MARK: Segue methods
    /// Method that manages the seguing to other view controllers from this view controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let squareSwappingView = segue.destination as? DraggableSquareGridViewController {
            self.squareGridViewController = squareSwappingView
        }
    }

    /// Feeds in the appropriate data for the use of seguing into this view.
    ///
    /// - Parameter viewModel: the game engine required to play this game.
    func segueWith(_ viewModel: SwappingViewModelProtocol) {
        super.segueWith(viewModel)
        self.viewModel = viewModel
    }

    // MARK: - Gesture Recognisers and Listeners
    /// Listens to a drag gesture and handles the operation of dragging a tile, and dropping it
    /// to another location.
    ///
    /// Note that if the game status is not in progress, results in no-op.
    @IBAction private func onTilesDragged(_ sender: UIPanGestureRecognizer) {
        guard viewModel.gameStatus == .inProgress else {
            return
        }

        let position = sender.location(in: squareGridViewController.view)

        switch sender.state {
        case .began:
            handleTileSelected(at: position)
        case .changed:
            handleTileDragged(at: position)
        case .ended:
            handleTileLanding(at: position)
        default:
            handleTileFailedLanding()
        }
    }

    /// Quit this screen when the back button is pressed.
    @IBAction private func onBackPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - Drag and Drop Tiles
fileprivate extension SwappingGameViewController {

    /// Handles the case when the tile is lifted from the collection view.
    /// Such a tile gets "detached" from the view by having its identity noted down in the
    /// properties.
    ///
    /// - Parameter position: location where the tile is selected.
    fileprivate func handleTileSelected(at position: CGPoint) {
        guard draggingTile == nil,
              squareGridViewController.detachedTiles.isEmpty,
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
        SoundService.sharedInstance.play(.snap)

        guard let landedCoord = squareGridViewController.getCoordinate(at: position),
              viewModel.swapTiles(draggingTile.originalCoord, and: landedCoord) else {
            handleTileFailedLanding()
            return
        }
        handleTileSuccessfulLanding(on: landedCoord)
    }

    /// Helper method to let the dragged tile to return to its original position.
    fileprivate func handleTileFailedLanding() {
        guard let tile = draggingTile else {
            return
        }
        self.draggingTile = nil
        squareGridViewController.snapDetachedTile(tile.view, toCoordinate: tile.originalCoord) {
            self.squareGridViewController.reattachDetachedTile(tile.view)
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
            self.squareGridViewController.reattachDetachedTile(startingView)
        }
        squareGridViewController.snapDetachedTile(endingView, toCoordinate: startingCoord) {
            self.squareGridViewController.reattachDetachedTile(endingView)
        }
    }
}
