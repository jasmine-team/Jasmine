import UIKit

class SlidingGameViewController: UIViewController {

    // MARK: - Layouts
    fileprivate var gameStatisticsView: GameStatisticsViewController!

    fileprivate var slidingGridView: DraggableSquareGridViewController!

    // MARK: - Properties
    fileprivate var viewModel: SlidingViewModelProtocol!

    fileprivate var movingTile: (tile: SquareTileView, from: Coordinate)?

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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if viewModel.gameStatus == .notStarted {
            viewModel.startGame()
        }
    }

    func segueWith(_ viewModel: SlidingViewModelProtocol) {
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }

    // MARK: Gestures and Listeners
    @IBAction func onBackPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    /// Handles the gesture where the user drags the tile to an empty slot.
    @IBAction func onTilesDragged(_ sender: UIDirectionalPanGestureRecognizer) {
        guard viewModel.gameStatus == .inProgress else {
            return
        }
        sender.touchedLocations.forEach { position in
            switch sender.state {
            case .began:
                onTileDraggedBegan(at: position)
            case .changed:
                onTileDragged(to: position, withDirection: sender.direction ?? .centre)
            case .ended:
                onTileDraggedEnded()
            default:
                break
            }
        }

    }
}

// MARK: - Sliding Tiles
fileprivate extension SlidingGameViewController {

    fileprivate func onTileDraggedBegan(at position: CGPoint) {
        guard let startingCoord = slidingGridView.getCoordinate(at: position),
              viewModel.canTileSlide(from: startingCoord),
              let tile = slidingGridView.detachTile(fromCoord: startingCoord) else {
            return
        }
        self.movingTile = (tile, startingCoord)
    }

    fileprivate func onTileDragged(to position: CGPoint, withDirection direction: Direction) {
        guard let movingTile = movingTile else {
            return
        }
        if direction.isHorizontal {
            slidingGridView.moveDetachedTile(movingTile.tile, toAlongXAxis: position.x)
        } else if direction.isVertical {
            slidingGridView.moveDetachedTile(movingTile.tile, toAlongYAxis: position.y)
        }
    }

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
              viewModel.slideTile(from: movingTile.from, to: endingCoord) else {

            helperSnapTile(toCoord: movingTile.from)
            return
        }
        helperSnapTile(toCoord: endingCoord)
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
