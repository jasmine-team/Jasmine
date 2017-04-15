import UIKit

/// Sets the base game view controller for all the view controller class.
/// - Note:
///   - The storyboard must contain:
///     - A segue to game over screen with "SegueToGameOverViewController" identifier
///     - A `SimpleStartGameViewController` view
///     - A `GameOverViewController` view.
class BaseGameViewController: JasmineViewController {

    // MARK: Constants
    fileprivate static let segueToGameOverView = "SegueToGameOverViewController"
    fileprivate static let segueDelay = 0.5

    // MARK: Properties
    fileprivate var baseViewModel: BaseViewModelProtocol!

    // MARK: Segue Methods
    /// Segue to base game views, including game start, game statistics and game over.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gameStartView = segue.destination as? SimpleStartGameViewController {
            setLayout(gameStartView: gameStartView, onScreenDismissed: startGameIfPossible)

        } else if let gameStatisticsView = segue.destination as? GameStatisticsViewController {
            setLayout(statisticsView: gameStatisticsView)

        } else if let gameOverView = segue.destination as? GameOverViewController {
            gameOverView.segueWith(baseViewModel)
        }
    }

    /// Segue to this view with a base view model.
    func segueWith(_ baseViewModel: BaseViewModelProtocol) {
        self.baseViewModel = baseViewModel
        self.baseViewModel.gameStatusDelegate = self
    }

    // MARK: Layout setters
    /// Sets the navigation bar properties given from the child class.
    func setLayout(navigationBar: UINavigationBar) {
        super.setLayout(navigationBar: navigationBar, withTitle: baseViewModel.gameTitle)
    }

    private func setLayout(gameStartView: SimpleStartGameViewController,
                           onScreenDismissed callback: @escaping () -> Void) {
        gameStartView.segueWith(baseViewModel, onScreenDismissed: callback)
    }

    private func setLayout(statisticsView: GameStatisticsViewController) {
        statisticsView.segueWith(time: baseViewModel, score: baseViewModel)
    }
}

// MARK: - Game Status
extension BaseGameViewController: GameStatusUpdateDelegate {

    /// Tells the implementor of the delegate that the game status has been updated.
    func gameStatusDidUpdate() {
        guard baseViewModel.gameStatus.hasGameEnded else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + BaseGameViewController.segueDelay) {
            self.performSegue(withIdentifier: BaseGameViewController.segueToGameOverView,
                              sender: nil)
        }
    }

    /// Starts the game if the game status is not started.
    func startGameIfPossible() {
        guard baseViewModel.gameStatus == .notStarted else {
            return
        }
        baseViewModel.startGame()
    }
}
