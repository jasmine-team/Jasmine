import UIKit

/// View Controller implementation for Swapping Game.
class SwappingGameViewController: UIViewController {

    // MARK: Layouts
    fileprivate var squareGridViewController: DraggableSquareGridViewController!

    fileprivate var statisticsViewController: GameStatisticsViewController!

    @IBOutlet private weak var navigationBar: UINavigationBar!

    @IBOutlet private weak var statusBarBackgroundView: UIView!

    fileprivate var draggingTile: (view: SquareTileView, originalCoord: Coordinate)?

    // MARK: Game Properties
    fileprivate var viewModel: SwappingViewModelProtocol!

    // MARK: View Controller Lifecycles
    /// Set its theme after the view controller `viewDidLoad` is called.
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheme()
    }

    /// This also starts the game if have not done so.
    ///
    /// - Parameter animated: true if the appearance of the view is animated
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if viewModel.gameStatus == .notStarted {
            viewModel.startGame()
        }
    }

    // MARK: Segue methods
    /// Method that manages the seguing to other view controllers from this view controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let squareSwappingView = segue.destination as? DraggableSquareGridViewController {
            squareSwappingView.segueWith(viewModel.gridData)
            self.squareGridViewController = squareSwappingView

        } else if let statisticsView = segue.destination as? GameStatisticsViewController {
            statisticsView.segueWith(timeLeft: viewModel.timeRemaining,
                                     currentScore: viewModel.currentScore)
            self.statisticsViewController = statisticsView
        }
    }

    /// Feeds in the appropriate data for the use of seguing into this view.
    ///
    /// - Parameter viewModel: the game engine required to play this game.
    func segueWith(_ viewModel: SwappingViewModelProtocol) {
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }

    // MARK: - Gesture Recognisers and Listeners
    /// Listens to a drag gesture and handles the operation of dragging a tile, and dropping it
    /// to another location.
    ///
    /// Note that if the game status is not in progress, results in no-op.
    @IBAction func onTilesDragged(_ sender: UIPanGestureRecognizer) {
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
            break
        }
    }

    /// Quit this screen when the back button is pressed.
    @IBAction func onBackPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: Theming
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    private func setTheme() {
        statusBarBackgroundView.backgroundColor = Constants.Theme.mainColorDark
        navigationBar.backgroundColor = Constants.Theme.mainColorDark
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
        guard let landedCoord = squareGridViewController.getCoordinate(at: position),
            viewModel.swapTiles(draggingTile.originalCoord, and: landedCoord) else {
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
            self.squareGridViewController.reattachDetachedTile(tile.view)
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
            self.squareGridViewController.reattachDetachedTile(startingView)
        }
        squareGridViewController.snapDetachedTile(endingView, toCoordinate: startingCoord) {
            self.squareGridViewController.reattachDetachedTile(endingView)
        }
    }
}

// MARK: - Delegate Conformance
extension SwappingGameViewController: SwappingGameViewControllerDelegate {
    // MARK: Score Update
    /// Redisplay the score displayed on the view controller screen with a new score.
    func redisplay(newScore: Int) {
        statisticsViewController.currentScore = newScore
    }

    // MARK: Time Update
    /// Redisplay the time remaining on the view controller against a total time.
    func redisplay(timeRemaining remainingTime: TimeInterval, outOf totalTime: TimeInterval) {
        statisticsViewController.timeLeft = remainingTime
    }

    // MARK: Game Status
    /// Notifies the view controller that the game state has changed.
    func notifyGameStatusUpdated() {

    }
}
