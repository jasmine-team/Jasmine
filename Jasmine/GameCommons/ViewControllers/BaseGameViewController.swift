import UIKit

/// Sets the base game view controller for all the view controller class.
class BaseGameViewController: JasmineViewController {

    // MARK: Constants
    fileprivate static let segueToGameOverView = "SegueToGameOverViewController"
    fileprivate static let segueDelay = 0.5

    // MARK: Properties
    fileprivate var baseViewModel: BaseViewModelProtocol!

    func segueWith(_ baseViewModel: BaseViewModelProtocol) {
        self.baseViewModel = baseViewModel
        self.baseViewModel.gameStatusDelegate = self
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
