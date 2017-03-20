import UIKit

/// Displays the statistics, such as time remaining and current score in this game.
class GameStatisticsViewController: UIViewController {

    // MARK: Layout
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var timeLeftLabel: UILabel!

    // MARK: Properties
    /// Sets the current score in this VC, which also updates the view elements automatically.
    var currentScore: Int? {
        didSet {
            displayCurrentScore()
        }
    }

    /// Sets the time remaining in this VC, which also updates the view elements automatically,
    /// rounded to integers.
    var timeLeft: TimeInterval? {
        didSet {
            displayTimeRemaining()
        }
    }

    // MARK: View Controller Lifecycle
    /// Presents the information on view after loading.
    override func viewWillAppear(_ animated: Bool) {
        displayCurrentScore()
        displayTimeRemaining()
    }

    // MARK: Helper Methods
    /// Displays the current score in the label, in integer.
    private func displayCurrentScore() {
        guard scoreLabel != nil else {
            return
        }
        guard let currentScore = currentScore else {
            scoreLabel.text = ""
            return
        }
        scoreLabel.text = "\(currentScore)"
    }

    /// Displays the time remaining in the label, in integer.
    private func displayTimeRemaining() {
        guard timeLeftLabel != nil else {
            return
        }
        guard let timeLeft = timeLeft else {
            timeLeftLabel.text = ""
            return
        }
        timeLeftLabel.text = "\(Int(round(timeLeft)))"
    }
}
