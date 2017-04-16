import UIKit

/// View Controller implementation for Tetris Game.
class TetrisGameViewController: BaseGameViewController {

    // MARK: - Constants
    private static let cellSpace: CGFloat = 2.0

    /// Denotes the delay in animation between explosion and falling.
    fileprivate static let animationDelay = 0.5

    // MARK: - Layouts
    fileprivate var tetrisGameAreaView: DiscreteFallableSquareGridViewController!

    fileprivate var tetrisUpcomingTilesView: SquareGridViewController!

    fileprivate var gameStatisticsView: GameStatisticsViewController!

    fileprivate var gameStartView: SimpleStartGameViewController!

    @IBOutlet fileprivate weak var navigationBar: UINavigationBar!

    // MARK: Game Properties
    fileprivate var viewModel: TetrisGameViewModelProtocol!

    fileprivate var upcomingTiles: TextGrid {
        return TextGrid(fromInitialRow: viewModel.upcomingTiles)
    }

    // MARK: View Controller Lifecycles
    /// Loads this current view and set the appropriate layout in the super views.
    override func viewDidLoad() {
        super.viewDidLoad()
        super.setLayout(navigationBar: navigationBar)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setFirstUpcomingTileStyle()
        if viewModel.gameStatus == .notStarted {
            releaseNewTile()
        }
    }

    // MARK: Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let tetrisGridView = segue.destination as? DiscreteFallableSquareGridViewController {
            self.tetrisGameAreaView = tetrisGridView
            helperSegueIntoTetrisGridView()

        } else if let upcomingView = segue.destination as? SquareGridViewController {
            self.tetrisUpcomingTilesView = upcomingView
            self.tetrisUpcomingTilesView.segueWith(upcomingTiles)
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
        super.segueWith(viewModel)
        self.viewModel = viewModel
    }

    // MARK: Gestures and Listeners
    /// Switches the content of the falling tile with the latest upcoming tile when any tile in the
    /// list of upcoming tile is tapped.
    @IBAction private func onUpcomingTilesTouched(_ sender: UITapGestureRecognizer) {
        guard viewModel.gameStatus == .inProgress,
              tetrisGameAreaView.hasFallingTile,
              let coord = tetrisUpcomingTilesView
                  .getCoordinate(at: sender.location(in: tetrisUpcomingTilesView.view)) else {
            return
        }
        viewModel.swapFallingTile(withUpcomingAt: coord.col)
        updateUpcomingAndFallingTiles()
    }

    /// Moves the falling tile when the view is swiped to a particular direction.
    @IBAction private func onTilesSwiped(_ sender: UISwipeGestureRecognizer) {
        guard viewModel.gameStatus == .inProgress,
              tetrisGameAreaView.hasFallingTile else {
            return
        }

        let direction = sender.direction.toDirection
        if direction.isHorizontal {
            tetrisGameAreaView.shiftFallingTile(towards: direction)
        } else if direction == .southwards {
            dropFallingTile()
        }
        SoundService.sharedInstance.play(.snap)
    }

    /// Moves the falling tile with respect to the position of the falling tile when the user taps
    /// on the grid.
    @IBAction private func onTilesTapped(_ sender: UITapGestureRecognizer) {
        guard viewModel.gameStatus == .inProgress,
              let tileFrame = tetrisGameAreaView.fallingTile?.frame else {
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
        SoundService.sharedInstance.play(.snap)
    }

    // MARK: - Game State and Actions
    /// Releases a new tile at the top row for falling.
    /// - Precondition: This method is only available if the game is not ended.
    /// - Postcondition: This tile will have been checked if it can land on the top row.
    private func releaseNewTile() {
        guard !tetrisGameAreaView.hasFallingTile,
              !viewModel.gameStatus.hasGameEnded,
              let tileText = viewModel.fallingTileText else {
            return
        }
        let tileCoord = viewModel.fallingTileStartCoordinate

        tetrisGameAreaView.setFallingTile(withData: tileText, toCoord: tileCoord)
        updateUpcomingAndFallingTiles()
        tryLandTile(at: tileCoord)
    }

    /// Drops the falling tile to the lowest unoccupied cell in the same column.
    private func dropFallingTile() {
        guard let initCoord = tetrisGameAreaView.fallingTileCoord else {
            return
        }
        let finalCoord = viewModel.getLandingCoordinate(from: initCoord)
        tetrisGameAreaView.landFallingTile(at: finalCoord)
    }

    /// Updates the current falling tile and the upcoming tiles with new data.
    private func updateUpcomingAndFallingTiles() {
        tetrisGameAreaView.fallingTile?.text = viewModel.fallingTileText
        tetrisUpcomingTilesView.reload(gridData: upcomingTiles, withAnimation: true)
    }

    /// Tells this view controller that the tile has shifted to a new position.
    private func notifyTileHasRepositioned() {
        guard let coord = tetrisGameAreaView.fallingTileCoord else {
            return
        }
        tryLandTile(at: coord)
    }

    /// Lands the tile at the specified coordinate if it is able to.
    ///
    /// - Parameter coordinate: the coordinate of the cell in the grid where the tile can land right onto.
    /// - Returns: true if the landing is permitted.
    @discardableResult
    private func tryLandTile(at coordinate: Coordinate) -> Bool {
        guard viewModel.canLandTile(at: coordinate) else {
            return false
        }
        tetrisGameAreaView.landFallingTile(at: coordinate)
        return true
    }

    /// Tells this view controller that the tile has landed successfully.
    private func notifyTileHasLanded(at coordinate: Coordinate) {
        let destroyedAndShiftedTiles = viewModel.landTile(at: coordinate)
        animate(removeAll: destroyedAndShiftedTiles, onComplete: nil)
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
    /// - Parameter callback: the method that will be called when the animation ends.
    fileprivate func animate(
        removeAll coords: [(destroyedTiles: Set<Coordinate>, shiftedTiles: [(from: Coordinate, to: Coordinate)])],
        onComplete callback: (() -> Void)?) {

        guard !coords.isEmpty else {
            callback?()
            return
        }

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

        DispatchQueue.main
            .asyncAfter(deadline: .now() + TetrisGameViewController.animationDelay * count) {
                self.tetrisGameAreaView.reload(gridData: self.viewModel.gridData, withAnimation: false)
                callback?()
            }
    }

    /// Ask the view controller to animate the destruction of tiles at the specified coordinates.
    ///
    /// - Parameter coodinates: the set of coordinates to be destroyed.
    fileprivate func animate(destroyTilesAt coordinates: Set<Coordinate>) {
        coordinates.flatMap { self.tetrisGameAreaView.getCell(at: $0) }
            .forEach { $0.animateExplosion() }
        SoundService.sharedInstance.play(.pop)
    }

    /// Shifts the content of the tiles from Coordinate `from` to Coordinate `to`
    ///
    /// - Parameter coordinatesShifted: array of coordinates to shift
    fileprivate func animate(shiftTiles coordinatesToShift: [(from: Coordinate, to: Coordinate)]) {
        for (start, end) in coordinatesToShift {
            guard let tile = self.tetrisGameAreaView.detachTile(fromCoord: start) else {
                return
            }
            self.tetrisGameAreaView.snapDetachedTile(tile, toCoordinate: end) {
                self.tetrisGameAreaView.reattachDetachedTile(tile)
            }
        }
    }
}

// MARK: - Game Status Override
extension TetrisGameViewController {

    /// Tells the implementor of the delegate that the game status has been updated.
    override func gameStatusDidUpdate() {
        guard viewModel.gameStatus.hasGameEnded else {
            return
        }
        super.gameStatusDidUpdate()
        tetrisGameAreaView.pauseFallingTiles()
    }

    /// Starts the game if the game status is not started.
    override func startGameIfPossible() {
        guard viewModel.gameStatus == .notStarted else {
            return
        }
        super.startGameIfPossible()
        tetrisGameAreaView.startFallingTiles(with: GameConstants.Tetris.tileFallInterval)
    }
}
