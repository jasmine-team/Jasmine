import UIKit

/// View Controller implementation for Sliding Grid Game.
class SlidingGameViewController: UIViewController {

    // MARK: - Layouts
    fileprivate var gameStatisticsView: GameStatisticsViewController!

    fileprivate var slidingGridView: DraggableSquareGridViewController!

    // MARK: - Properties
    fileprivate var viewModel: SlidingViewModelProtocol!

    fileprivate var movingTile:
        (tile: SquareTileView, fromCoord: Coordinate, toCoord: [Direction: Coordinate])?

    // MARK: - Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let slidingGridView = segue.destination as? DraggableSquareGridViewController {
            slidingGridView.segueWith(viewModel.gridData,
                                      numRows: Constants.Game.Sliding.rows,
                                      numCols: Constants.Game.Sliding.columns)
            self.slidingGridView = slidingGridView

        } else if let gameStatisticsView = segue.destination as? GameStatisticsViewController {
            gameStatisticsView.segueWith(timeLeft: viewModel.timeRemaining,
                                         currentScore: viewModel.currentScore)
            self.gameStatisticsView = gameStatisticsView
        }
    }

    // MARK: - View Controller Lifecycle
    /// Starts the game when the view appears.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if viewModel.gameStatus == .notStarted {
            viewModel.startGame()
        }
    }

    /// Injects the required data before opening this view.
    ///
    /// - Parameter viewModel: the view model of this class.
    func segueWith(_ viewModel: SlidingViewModelProtocol) {
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }

    // MARK: Gestures and Listeners
    /// Dismisses this current screen when "Back" button is pressed.
    @IBAction func onBackPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    /// Handles the gesture where the user drags the tile to an empty slot.
    @IBAction func onTilesDragged(_ sender: UIPanGestureRecognizer) {
        guard viewModel.gameStatus == .inProgress else {
            return
        }

        let position = sender.location(in: slidingGridView.view)
        switch sender.state {
        case .began:
            onTileDraggedBegan(at: position)
        case .changed:
            onTileDragged(to: position)
        case .ended:
            onTileDraggedEnded()
        default:
            break
        }
    }
}

// MARK: - Sliding Tiles
fileprivate extension SlidingGameViewController {

    /// Handles when the tile starts to slide at the specified position.
    fileprivate func onTileDraggedBegan(at position: CGPoint) {
        guard let startingCoord = slidingGridView.getCoordinate(at: position) else {
            return
        }

        let destinations = viewModel.canTileSlide(from: startingCoord)
        guard !destinations.isEmpty else {
            return
        }

        guard let tile = slidingGridView.detachTile(fromCoord: startingCoord) else {
            return
        }

        self.movingTile = (tile, startingCoord, destinations)
    }

    /// Handles when the tile is currently sliding to the specified position.
    /// Also restraints the tile from sliding too far off the allowed coordinates in `movingTile`.
    fileprivate func onTileDragged(to position: CGPoint) {
        guard let movingTile = movingTile,
              let originalPos = slidingGridView.getCenter(from: movingTile.fromCoord) else {
            return
        }

        let finalPosition = position
            .alignToAxis(fromOrigin: originalPos)
            .fitWithin(boundingBox: getBoundingBox(from: movingTile.toCoord, refPoint: originalPos))

        slidingGridView.moveDetachedTile(movingTile.tile, toPosition: finalPosition)
    }

    /// Handles the attachment of tile back to the grid after the sliding is complete.
    fileprivate func onTileDraggedEnded() {
        guard let movingTile = movingTile else {
            return
        }

        func helperSnapTile(toCoord coord: Coordinate) {
            slidingGridView.snapDetachedTile(movingTile.tile, toCoordinate: coord) {
                self.slidingGridView.reattachDetachedTile(movingTile.tile)
                self.redisplayAllTiles()
                self.movingTile = nil
            }
        }

        guard let endingCoord = slidingGridView.getCoordinate(at: movingTile.tile.center),
            viewModel.slideTile(from: movingTile.fromCoord, to: endingCoord) else {

                helperSnapTile(toCoord: movingTile.fromCoord)
                return
        }
        helperSnapTile(toCoord: endingCoord)
    }

    /// Helper method to get the bounding box from the specified `destination` map and the reference
    /// point.
    ///
    /// - Parameters:
    ///   - destination: the destination map of direction, and the further reachable coordinate that
    ///     the tile can be slided to.
    ///   - refPoint: the reference point, which is the starting position of the tile.
    /// - Returns: a bounding rectangle of the area that the tile can be slided.
    private func getBoundingBox(from destination: [Direction: Coordinate], refPoint: CGPoint) -> CGRect {

        /// Helper method to get the center position of the coordinate.
        /// If such a center is not found (maybe cannot slide beyond the initial point), returns
        /// `refPoint` instead.
        func getCenter(from coord: Coordinate?) -> CGPoint {
            guard let coord = coord,
                  let center = slidingGridView.getCenter(from: coord) else {
                return refPoint
            }
            return center
        }

        let northY = getCenter(from: destination[.northwards]).y
        let southY = getCenter(from: destination[.southwards]).y

        let eastX = getCenter(from: destination[.eastwards]).x
        let westX = getCenter(from: destination[.westwards]).x

        return CGRect(minX: westX, maxX: eastX, minY: northY, maxY: southY)
    }
}

extension SlidingGameViewController: SlidingGameViewControllerDelegate {
    /// Update the grid data stored in the Grid Game View Controller with a new dataset.
    func updateGridData() {
        slidingGridView.update(collectionData: viewModel.gridData)
    }

    /// Refreshes the tiles based on the tiles information stored in the View Controller's grid data.
    ///
    /// Note to call `updateGridData` if any information in the grid data should be
    /// updated.
    func redisplayAllTiles() {
        slidingGridView.reload(allCellsWithAnimation: true)
    }
}

extension SlidingGameViewController: BaseGameViewControllerDelegate {

    // MARK: Score Update
    /// Redisplay the score displayed on the view controller screen with a new score.
    ///
    /// - Parameter newScore: the new score to be redisplayed.
    func redisplay(newScore: Int) {
        gameStatisticsView.currentScore = newScore
    }

    // MARK: Time Update
    /// Redisplay the time remaining on the view controller against a total time.
    ///
    /// - Parameters:
    ///   - timeRemaining: the time remaining, in seconds.
    ///   - totalTime: the total time from the start of the game, in seconds.
    func redisplay(timeRemaining: TimeInterval, outOf totalTime: TimeInterval) {
        gameStatisticsView.timeLeft = timeRemaining
    }

    // MARK: Game Status
    /// Notifies the view controller that the game state has changed.
    ///
    /// This is also the place to indicate when the user has won/lost.
    /// Note also that if the user has won/lost, the score in the `redisplay(_ newScore)` will be
    /// taken as the end game score. So update it before calling end game.
    func notifyGameStatusUpdated() {

    }
}
