import UIKit

class TetrisGameViewController: UIViewController {

    // MARK: - Constants
    private static let tetrisGameAreaIdentifier = "Tetris Game Area"
    private static let tetrisUpcomingTilesIdentifier = "Tetris Upcoming Tiles"

    // MARK: - Layouts
    private var tetrisGameArea: SquareGridViewController!

    private var tetrisUpcomingTilesArea: SquareGridViewController!

    private var gameStatisticsView: GameStatisticsViewController!

    // MARK: Game Properties
    fileprivate var viewModel: TetrisViewModelProtocol!

    private var upcomingTiles: [Coordinate: String] {
        var outcome: [Coordinate: String] = [:]
        (0..<Constants.Game.Tetris.upcomingTilesCount)
            .map { (location: $0, data: viewModel.upcomingTiles[$0]) }
            .forEach { outcome[Coordinate(row: 0, col: $0.location)] = $0.data }
        return outcome
    }

    // MARK: View Controller Lifecycles
    /// Specifies that the supported orientation for this view is portrait only.
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    // MARK: Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let squareGridView = segue.destination as? SquareGridViewController {
            if segue.identifier == TetrisGameViewController.tetrisGameAreaIdentifier {
                squareGridView.segueWith([:], numRows: Constants.Game.Tetris.rows,
                                         numCols: Constants.Game.Tetris.columns, needSpace: false)
                self.tetrisGameArea = squareGridView

            } else if segue.identifier == TetrisGameViewController.tetrisUpcomingTilesIdentifier {
                squareGridView.segueWith(upcomingTiles, numRows: 1,
                                         numCols: Constants.Game.Tetris.upcomingTilesCount)
                self.tetrisUpcomingTilesArea = squareGridView
            }

        } else if let statisticsView = segue.destination as? GameStatisticsViewController {
            statisticsView.segueWith(timeLeft: viewModel.timeRemaining,
                                     currentScore: viewModel.currentScore)
            self.gameStatisticsView = statisticsView
        }
    }

    /// Feeds in the appropriate data for the use of seguing into this view.
    ///
    /// - Parameter viewModel: the game engine required to play this game.
    func segueWith(_ viewModel: TetrisViewModelProtocol) {
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }
}

extension TetrisGameViewController: TetrisGameViewControllerDelegate {

    /// Tells the view controller to retrieve `upcomingTiles` and reload the view for the upcoming tiles.
    func redisplayUpcomingTiles() {

    }

    // MARK: Animation
    /// Ask the view controller to animate the destruction of tiles at the specified coordinates.
    ///
    /// - Parameter coodinates: the set of coordinates to be destroyed.
    func animate(destroyTilesAt coodinates: Set<Coordinate>) {

    }

    /// Shifts the content of the tiles from Coordinate `from` to Coordinate `to`
    ///
    /// - Parameter coordinatesShifted: array of coordinates to shift
    func animate(shiftTiles coordinatesToShift: [(from: Coordinate, to: Coordinate)]) {

    }
}

extension TetrisGameViewController: BaseGameViewControllerDelegate {

    // MARK: Score Update
    /// Redisplay the score displayed on the view controller screen with a new score.
    ///
    /// - Parameter newScore: the new score to be redisplayed.
    func redisplay(newScore: Int) {

    }

    // MARK: Time Update
    /// Redisplay the time remaining on the view controller against a total time.
    ///
    /// - Parameters:
    ///   - timeRemaining: the time remaining, in seconds.
    ///   - totalTime: the total time from the start of the game, in seconds.
    func redisplay(timeRemaining: TimeInterval, outOf totalTime: TimeInterval) {

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
