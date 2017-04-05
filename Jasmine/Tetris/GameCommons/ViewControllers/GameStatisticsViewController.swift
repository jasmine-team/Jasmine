import UIKit

/// Displays the statistics, such as time remaining and current score in this game.
class GameStatisticsViewController: UIViewController {

    // MARK: Layout
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var timeLeftLabel: UILabel!

    // MARK: Properties
    fileprivate var timeDescriptor: TimeDescriptorProtocol!
    fileprivate var scoreDescriptor: ScoreDescriptorProtocol!

    // TODO: Update them away.
    /// Sets the current score in this VC, which also updates the view elements automatically.
    fileprivate var currentScore: Int? {
        didSet {
            displayCurrentScore()
        }
    }

    /// Sets the time remaining in this VC, which also updates the view elements automatically,
    /// rounded to integers.
    fileprivate var timeLeft: TimeInterval? {
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

    // MARK: Segue methods
    /// Feed in the appropriate data before seguing into this view.
    ///
    /// - Parameters:
    ///   - timeDescriptor: a protocol conformance that describes the time (remaining)
    ///   - currentScore: a protocol conformance that describes the current score.
    func segueWith(time timeDescriptor: TimeDescriptorProtocol,
                   score scoreDescriptor: ScoreDescriptorProtocol) {
        self.timeDescriptor = timeDescriptor
        self.timeDescriptor.timeDelegate = self

        self.scoreDescriptor = scoreDescriptor
        self.scoreDescriptor.scoreDelegate = self
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

extension GameStatisticsViewController: TimeUpdateDelegate {

    /// Tells the implementor of the delegate that the time has been updated.
    func timeDidUpdate() {
        self.timeLeft = timeDescriptor.timeRemaining
    }
}

extension GameStatisticsViewController: ScoreUpdateDelegate {

    /// Tells the implementor of the delegate that the score has been updated.
    func scoreDidUpdate() {
        self.currentScore = scoreDescriptor.currentScore
    }
}
