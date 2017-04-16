import GameKit

class ProfileViewController: JasmineViewController {

    @IBOutlet private var playerNameLabel: UILabel!

    @IBOutlet private weak var navigationBar: UINavigationBar!

    private static let weeklyStreakGridSpacing: CGFloat = 0
    private static let weeklyStreakNumRows = 4
    private static let weeklyStreakNumCols = 13

    override func viewDidLoad() {
        super.viewDidLoad()
        super.setLayout(navigationBar: navigationBar)
        setPlayerNameLabel()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let squareGridViewController = segue.destination as? SquareGridViewController {
            squareGridViewController.segueWith(numRow: ProfileViewController.weeklyStreakNumRows,
                                               numCol: ProfileViewController.weeklyStreakNumCols,
                                               withSpace: ProfileViewController.weeklyStreakGridSpacing)
        }
    }

    /// Sets the player name label text if user is authenticated
    private func setPlayerNameLabel() {
        let localPlayer = GKLocalPlayer.localPlayer()
        guard localPlayer.isAuthenticated else {
            return
        }
        playerNameLabel.text = localPlayer.alias
    }

    @IBAction private func showAchievements(_ sender: UIButton) {
        segueTo(.achievements)
    }

    @IBAction private func showLeaderboards(_ sender: UIButton) {
        segueTo(.leaderboards)
    }

    /// Performs user authentication and segue to the game center with the screen associated with `viewState`
    ///
    /// - Parameter viewState: the screen associated with it to display
    private func segueTo(_ viewState: GKGameCenterViewControllerState) {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            presentGameCenter(viewState)
            return
        }
        guard !showGKSignInInstruction() else {
            return
        }

        setGKAuthHandler {
            self.presentGameCenter(viewState)
            self.setPlayerNameLabel()
        }
    }

    /// Presents the game center with the screen associated with `viewState`
    ///
    /// - Parameter viewState: the screen associated with it to display
    private func presentGameCenter(_ viewState: GKGameCenterViewControllerState) {
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.gameCenterDelegate = self
        gameCenterViewController.viewState = viewState
        self.present(gameCenterViewController, animated: true)
    }
}

extension ProfileViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}
