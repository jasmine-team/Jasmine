import UIKit
import GameKit

class ProfileViewController: UIViewController {

    @IBAction func showAchievements(_ sender: UIButton) {
        segueToGameCenter(.achievements)
    }

    @IBAction func showLeaderboards(_ sender: UIButton) {
        segueToGameCenter(.leaderboards)
    }

}

// Delegate to dismiss the GC controller
extension ProfileViewController: GKGameCenterControllerDelegate {

    /// Show game center controller with a specific state
    ///
    /// - Parameter viewState: enum state of the game center view controller
    func segueToGameCenter(_ viewState: GKGameCenterViewControllerState) {
        let localPlayer = GKLocalPlayer.localPlayer()
        if localPlayer.isAuthenticated {
            helperPresent(viewState)
            return  // early return, no need to authenticate
        }
        localPlayer.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                // 1. Show login if player is not logged in
                self.present(viewController, animated: true)
            } else if localPlayer.isAuthenticated {
                self.helperPresent(viewState)
            } else {
                // Game center is disabled for user
                return
            }
        }
    }

    /// Helper function to show the game center view controller screen
    ///
    /// - Parameter viewState: view state to show
    func helperPresent(_ viewState: GKGameCenterViewControllerState) {
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        gameCenterViewController.viewState = viewState
        self.present(gameCenterViewController, animated: true, completion: nil)
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }

}
