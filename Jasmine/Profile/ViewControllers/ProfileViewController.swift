import GameKit

class ProfileViewController: UIViewController {

    @IBOutlet private var playerNameLabel: UILabel!

    private var weeklyStreakGrid: SquareGridViewController!

    @IBOutlet private var dailyStreakFlower: UIImageView!

    private static let weeklyStreakGridSpacing: CGFloat = 2.0
    private static let weeklyStreakMinAlpha: CGFloat = 0.1
    private static let weeklyStreakNumRows = 4
    private static let weeklyStreakNumCols = 13

    /// VM for this VC. Initialized in viewDidLoad
    private var viewModel: ProfileViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViewModel()
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

    private func initializeViewModel() {
        do {
            try viewModel = ProfileViewModel(numWeeksToCount: ProfileViewController.weeklyStreakNumRows *
                                                              ProfileViewController.weeklyStreakNumCols)
        } catch {
            showError(error)
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
        dailyStreakFlower.image = Constants.Graphics.Petals.frames[viewModel.dailyStreakCount]
    }

    /// Sets the weekly streak grid
    private func setWeeklyStreak() {
        let weeklyStreakCounts = viewModel.weeklyStreakCounts
        for col in 0..<ProfileViewController.weeklyStreakNumCols {
            for row in 0..<ProfileViewController.weeklyStreakNumRows {
                let coordinate = Coordinate(row: row, col: col)
                let streakCount = weeklyStreakCounts[col * ProfileViewController.weeklyStreakNumRows + row]
                let ratio = CGFloat(streakCount) / CGFloat(self.viewModel.numOfDaysInAWeek)
                setStreakGrid(at: coordinate, intensity: ratio)
            }
        }
    }

    /// Sets alpha of the streak grid at `coordinate` based on `intensity`
    ///
    /// - Parameters:
    ///   - coordinate: coordinate of the streak grid to set
    ///   - intensity: a value between 0.0 and 1.0 to adjust the alpha to
    private func setStreakGrid(at coordinate: Coordinate, intensity: CGFloat) {
        weeklyStreakGrid.cellProperties[coordinate] = { cell in
            cell.backgroundColor = Constants.Theme.mainColor
            cell.alpha = ProfileViewController.weeklyStreakMinAlpha +
                         (1 - ProfileViewController.weeklyStreakMinAlpha) * intensity
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
