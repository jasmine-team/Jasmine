import UIKit

/// View Controller implementation for Tetris Game.
class TetrisGameViewController: UIViewController {

    // MARK: - Constants
    private static let cellSpace: CGFloat = 2.0

    fileprivate static let segueToGameOverView = "SegueToGameOverViewController"

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
        startGame()
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

        tetrisGameAreaView.segueWith(numRow: GameConstants.Tetris.rows,
                                     numCol: GameConstants.Tetris.columns,
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
        guard tetrisGameAreaView.hasFallingTile,
              sender.direction != .up else {
            return
        }
        tetrisGameAreaView.shiftFallingTile(towards: sender.direction.toDirection)
    }

    /// Moves the falling tile with respect to the position of the falling tile when the user taps
    /// on the grid.
    @IBAction func onTilesTapped(_ sender: UITapGestureRecognizer) {
        guard let tilePosition = tetrisGameAreaView.fallingTile?.center else {
            return
        }

        let touchedPosition = sender.location(in: tetrisGameAreaView.view)
        let direction: Direction = touchedPosition.x > tilePosition.x ? .eastwards : .westwards
        tetrisGameAreaView.shiftFallingTile(towards: direction)
    }

    // MARK: - Game State and Actions
    private func startGame() {
        viewModel.startGame()
        tetrisGameAreaView.startFallingTiles(with: GameConstants.Tetris.tileFallInterval)
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
        // TODO : synchronize the animation of the sequence of destroyed and shifted tiles
        for tiles in destroyedAndShiftedTiles {
            animate(destroyedTiles: tiles.destroyedTiles, shiftedTiles: tiles.shiftedTiles)
        }
        releaseNewTile()
    }

    // MARK: - Layout Helper Methods
    private func setFirstUpcomingTileStyle() {
        tetrisUpcomingTilesView.tileProperties[.origin] = { (tile: SquareTileView) in
            tile.textColor = Constants.Theme.secondaryColor
        }
    }
}

extension TetrisGameViewController {

    // MARK: Animation
    /// Ask the view controller to animate the destruction of tiles at the specified coordinates,
    /// and then shift the content of the tiles from Coordinate `from` to Coordinate `to`.
    ///
    /// - Parameters:
    ///   - coodinates: the set of coordinates to be destroyed.
    ///   - coordinatesShifted: array of coordinates to shift
    func animate(destroyedTiles coordinates: Set<Coordinate>,
                 shiftedTiles coordinatesToShift: [(from: Coordinate, to: Coordinate)]) {

        self.animate(destroyTilesAt: coordinates)

        DispatchQueue.main.asyncAfter(deadline: .now() + TetrisGameViewController.animationDelay) {
            self.animate(shiftTiles: coordinatesToShift)
        }
    }

    /// Ask the view controller to animate the destruction of tiles at the specified coordinates.
    ///
    /// - Parameter coodinates: the set of coordinates to be destroyed.
    private func animate(destroyTilesAt coordinates: Set<Coordinate>) {
        coordinates.flatMap { self.tetrisGameAreaView.getCell(at: $0) }
            .forEach { $0.animateExplosion() }
    }

    /// Shifts the content of the tiles from Coordinate `from` to Coordinate `to`
    ///
    /// - Parameter coordinatesShifted: array of coordinates to shift
    private func animate(shiftTiles coordinatesToShift: [(from: Coordinate, to: Coordinate)]) {
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
        if viewModel.gameStatus.hasGameEnded {
            self.performSegue(withIdentifier: TetrisGameViewController.segueToGameOverView,
                              sender: nil)
        }
    }
}
