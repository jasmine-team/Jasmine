import GameKit

class ProfileViewController: JasmineViewController {

    @IBOutlet private var playerNameLabel: UILabel!
    @IBOutlet private var dailyStreakFlower: UIImageView!
    @IBOutlet private weak var navigationBar: UINavigationBar!
    private var weeklyStreakGrid: SquareGridViewController!

    private static let weeklyStreakGridSpacing: CGFloat = 2.0
    private static let weeklyStreakNumRows = 4
    private static let weeklyStreakNumCols = 13

    override func viewDidLoad() {
        super.viewDidLoad()
        super.setLayout(navigationBar: navigationBar)
        setPlayerNameLabel()
        setDailyStreak()
        setWeeklyStreak()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let squareGridViewController = segue.destination as? SquareGridViewController {
            squareGridViewController.segueWith(numRow: ProfileViewController.weeklyStreakNumRows,
                                               numCol: ProfileViewController.weeklyStreakNumCols,
                                               withSpace: ProfileViewController.weeklyStreakGridSpacing)
            weeklyStreakGrid = squareGridViewController
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

    /// Sets the number of flowers for daily streak.
    private func setDailyStreak() {
        // TODO: Complete this code.
        let days = 4
        dailyStreakFlower.image = Constants.Graphics.Petals.frames[days]
    }

    private func setWeeklyStreak() {
        // TODO: Complete this code. This is how you specify a theme for a partiular cell.
        // Most likely have to convert coordinate to an index.
        weeklyStreakGrid.cellProperties[Coordinate.origin] = { cell in
            cell.backgroundColor = Constants.Theme.mainColor
            cell.alpha = 0.5 // TODO: Alpha can be = numDaysCompleted / 7.0
        }
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
