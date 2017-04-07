import UIKit

/// View Controller implementation for Tetris Game.
class TetrisGameViewController: UIViewController {

    // MARK: - Constants
    private static let cellSpace: CGFloat = 2.0

    fileprivate static let segueToGameOverView = "SegueToGameOverViewController"

    fileprivate static let segueDelay = 0.5

    /// Denotes the delay in animation between explosion and falling.
    fileprivate static let animationDelay = 0.5

    // MARK: - Layouts
    fileprivate var tetrisGameAreaView: DiscreteFallableSquareGridViewController!

    fileprivate var tetrisUpcomingTilesView: SquareGridViewController!

    fileprivate var gameStatisticsView: GameStatisticsViewController!

    // MARK: Game Properties
    fileprivate var viewModel: TetrisGameViewModelProtocol!

    fileprivate var upcomingTiles: TextGrid {
        return TextGrid(fromInitialRow: viewModel.upcomingTiles)
    }

    // MARK: View Controller Lifecycles
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setFirstUpcomingTileStyle()

        if viewModel.gameStatus == .notStarted {
            startGame()
        }
    }

    // MARK: Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tetrisGridView = segue.destination as? DiscreteFallableSquareGridViewController {
            self.tetrisGameAreaView = tetrisGridView
            helperSegueIntoTetrisGridView()

        } else if let upcomingView = segue.destination as? SquareGridViewController {
            upcomingView.segueWith(upcomingTiles)
            self.tetrisUpcomingTilesView = upcomingView

        } else if let statisticsView = segue.destination as? GameStatisticsViewController {
            statisticsView.segueWith(time: viewModel, score: viewModel)
            self.gameStatisticsView = statisticsView

        } else if let gameOverView = segue.destination as? GameOverViewController {
            gameOverView.segueWith(viewModel)
        }
    }

    /// Helper method to set up tetris grid view in segue
    private func helperSegueIntoTetrisGridView() {
        tetrisGameAreaView.onFallingTileRepositioned = notifyTileHasRepositioned
        tetrisGameAreaView.onFallingTileLanded = notifyTileHasLanded
        tetrisGameAreaView.canRepositionDetachedTileToCoord = { tile, coord in
            guard tile == self.tetrisGameAreaView.fallingTile else {
                return true
            }
            return self.viewModel.canShiftFallingTile(to: coord)
        }

        tetrisGameAreaView.segueWith(numRow: Constants.Game.Tetris.rows,
                                     numCol: Constants.Game.Tetris.columns,
                                     withSpace: TetrisGameViewController.cellSpace)
    }

    /// Feeds in the appropriate data for the use of seguing into this view.
    ///
    /// - Parameter viewModel: the game engine required to play this game.
    func segueWith(_ viewModel: TetrisGameViewModelProtocol) {
        self.viewModel = viewModel
        self.viewModel.gameStatusDelegate = self
    }

    // MARK: Gestures and Listeners
    /// Dismisses this view when the back button is pressed.
    @IBAction func onBackPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    /// Switches the content of the falling tile with the latest upcoming tile when any tile in the
    /// list of upcoming tile is tapped.
    @IBAction func onUpcomingTilesTouched(_ sender: UITapGestureRecognizer) {
        guard tetrisGameAreaView.hasFallingTile,
              let coord = tetrisUpcomingTilesView
                  .getCoordinate(at: sender.location(in: tetrisUpcomingTilesView.view)) else {
            return
        }
        viewModel.swapFallingTile(withUpcomingAt: coord.col)
        updateUpcomingAndFallingTiles()
    }

    /// Moves the falling tile when the view is swiped to a particular direction.
    @IBAction func onTilesSwiped(_ sender: UISwipeGestureRecognizer) {
        guard tetrisGameAreaView.hasFallingTile else {
            return
        }

        let direction = sender.direction.toDirection
        if direction.isHorizontal {
            tetrisGameAreaView.shiftFallingTile(towards: direction)
        } else if direction == .southwards {
            dropFallingTile()
        }

    }

    /// Moves the falling tile with respect to the position of the falling tile when the user taps
    /// on the grid.
    @IBAction func onTilesTapped(_ sender: UITapGestureRecognizer) {
        guard let tileFrame = tetrisGameAreaView.fallingTile?.frame else {
            return
        }

        let touchedPosition = sender.location(in: tetrisGameAreaView.view)
        let tileCenter = tileFrame.center
        let hasTouchedSouth = tileFrame.minX...tileFrame.maxX ~= touchedPosition.x
            && tileFrame.midY < touchedPosition.y

        if hasTouchedSouth {
            dropFallingTile()
        } else {
            let direction: Direction = touchedPosition.x > tileCenter.x ? .eastwards : .westwards
            tetrisGameAreaView.shiftFallingTile(towards: direction)
        }
    }

    // MARK: - Game State and Actions
    private func startGame() {
        viewModel.startGame()
        tetrisGameAreaView.startFallingTiles(with: Constants.Game.Tetris.tileFallInterval)
        releaseNewTile()
    }

    private func releaseNewTile() {
        guard !tetrisGameAreaView.hasFallingTile else {
            assertionFailure("Current tile still falling! Cannot release a new tile for falling!")
            return
        }
        tetrisGameAreaView.setFallingTile(withData: viewModel.fallingTileText,
                                          toCoord: viewModel.fallingTileStartCoordinate)
        updateUpcomingAndFallingTiles()
    }

    private func dropFallingTile() {
        guard let initCoord = tetrisGameAreaView.fallingTileCoord else {
            return
        }
        let finalCoord = viewModel.getLandingCoordinate(from: initCoord)
        tetrisGameAreaView.shiftFallingTile(to: finalCoord)
    }

    private func updateUpcomingAndFallingTiles() {
        tetrisGameAreaView.fallingTile?.text = viewModel.fallingTileText
        tetrisUpcomingTilesView.reload(gridData: upcomingTiles, withAnimation: true)
    }

    private func notifyTileHasRepositioned() {
        guard let coord = tetrisGameAreaView.fallingTileCoord,
              viewModel.canLandTile(at: coord) else {
            return
        }
        tetrisGameAreaView.landFallingTile(at: coord)
    }

    private func notifyTileHasLanded(at coordinate: Coordinate) {
        let destroyedAndShiftedTiles = viewModel.landTile(at: coordinate)
        animate(removeAll: destroyedAndShiftedTiles)
        releaseNewTile()
    }

    // MARK: - Helper Methods
    private func setFirstUpcomingTileStyle() {
        tetrisUpcomingTilesView.tileProperties[.origin] = { tile in
            tile.shouldHighlight = true
        }
    }
}

extension TetrisGameViewController {

    // MARK: Animation
    /// Ask the view controller to animate the destruction of tiles at the specified coordinates,
    /// and then shift the content of the tiles from Coordinate `from` to Coordinate `to`, in this
    /// order as governed by the coords array.
    ///
    /// - Parameter coords: the list of coordinates to perform destroy and then shift in order.
    fileprivate func animate(
        removeAll coords: [(destroyedTiles: Set<Coordinate>, shiftedTiles: [(from: Coordinate, to: Coordinate)])]) {

        var count = 0.0
        for (destroyedTiles, shiftedTiles) in coords {
            DispatchQueue.main
                .asyncAfter(deadline: .now() + TetrisGameViewController.animationDelay * count) {
                    self.animate(destroyTilesAt: destroyedTiles)
                }
            count += 1.0

            DispatchQueue.main
                .asyncAfter(deadline: .now() + TetrisGameViewController.animationDelay * count) {
                    self.animate(shiftTiles: shiftedTiles)
                }
            count += 1.0
        }
    }

    /// Ask the view controller to animate the destruction of tiles at the specified coordinates.
    ///
    /// - Parameter coodinates: the set of coordinates to be destroyed.
    fileprivate func animate(destroyTilesAt coordinates: Set<Coordinate>) {
        coordinates.flatMap { self.tetrisGameAreaView.getCell(at: $0) }
            .forEach { $0.animateExplosion() }
    }

    /// Shifts the content of the tiles from Coordinate `from` to Coordinate `to`
    ///
    /// - Parameter coordinatesShifted: array of coordinates to shift
    fileprivate func animate(shiftTiles coordinatesToShift: [(from: Coordinate, to: Coordinate)]) {
        coordinatesToShift.forEach {
            guard let tile = self.tetrisGameAreaView.detachTile(fromCoord: $0.from) else {
                return
            }
            self.tetrisGameAreaView.snapDetachedTile(tile, toCoordinate: $0.to) {
                self.tetrisGameAreaView.reattachDetachedTile(tile)
            }
        }
    }
}

// MARK: - Game Status
extension TetrisGameViewController: GameStatusUpdateDelegate {

    /// Tells the implementor of the delegate that the game status has been updated.
    func gameStatusDidUpdate() {
        guard viewModel.gameStatus.hasGameEnded else {
            return
        }

        tetrisGameAreaView.pauseFallingTiles()
        DispatchQueue.main.asyncAfter(deadline: .now() + TetrisGameViewController.segueDelay) {
            self.performSegue(withIdentifier: TetrisGameViewController.segueToGameOverView,
                              sender: nil)
        }
    }
}
