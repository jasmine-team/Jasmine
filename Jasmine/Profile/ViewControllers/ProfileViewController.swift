import UIKit
import GameKit

class ProfileViewController: UIViewController {

    @IBAction func showLeaderboards(_ sender: UIButton) {
        segueTo(.leaderboards)
    }

    @IBAction func showAchievements(_ sender: UIButton) {
        segueTo(.achievements)
    }

}

// Delegate to dismiss the GC controller
extension ProfileViewController: GKGameCenterControllerDelegate {

    func segueTo(_ viewState: GKGameCenterViewControllerState) {
        let localPlayer = GKLocalPlayer.localPlayer()
        if localPlayer.isAuthenticated {
            helperPresent(viewState)
        }
        localPlayer.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                // 1. Show login if player is not logged in
                self.present(viewController, animated: true)
            } else if localPlayer.isAuthenticated {
                self.segueTo(viewState)
            } else {
                // Game center is disabled for user
                return
            }
        }
    }

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
