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
            guard let currentScore = currentScore else {
                scoreLabel.text = ""
                return
            }
            scoreLabel.text = "\(currentScore)"
        }
    }

    /// Sets the time remaining in this VC, which also updates the view elements automatically,
    /// rounded to integers.
    var timeLeft: TimeInterval? {
        didSet {
            guard let timeLeft = timeLeft else {
                timeLeftLabel.text = ""
                return
            }
            timeLeftLabel.text = "\(round(timeLeft))"
        }
    }
}
