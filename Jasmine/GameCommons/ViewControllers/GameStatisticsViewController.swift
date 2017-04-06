import UIKit

/// Displays the statistics, such as time remaining and current score in this game.
class GameStatisticsViewController: UIViewController {

    // MARK: Layout
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var timeLeftLabel: UILabel!

    // MARK: Properties
    fileprivate var timeDescriptor: TimeDescriptorProtocol!
    fileprivate var scoreDescriptor: ScoreDescriptorProtocol!

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
    fileprivate func displayCurrentScore() {
        scoreLabel.text = "\(scoreDescriptor.currentScore)"
    }

    /// Displays the time remaining in the label, in integer.
    fileprivate func displayTimeRemaining() {
        timeLeftLabel.text = "\(Int(round(timeDescriptor.timeRemaining)))"
    }
}

extension GameStatisticsViewController: TimeUpdateDelegate {

    /// Tells the implementor of the delegate that the time has been updated.
    func timeDidUpdate() {
        displayTimeRemaining()
    }
}

extension GameStatisticsViewController: ScoreUpdateDelegate {

    /// Tells the implementor of the delegate that the score has been updated.
    func scoreDidUpdate() {
        displayCurrentScore()
    }
}
