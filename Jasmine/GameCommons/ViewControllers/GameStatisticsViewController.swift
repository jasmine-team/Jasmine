import UIKit

/// Displays the statistics, such as time remaining and current score in this game.
class GameStatisticsViewController: UIViewController {

    // MARK: Constants
    private static let flashScale: CGFloat = 2.0
    private static let flashDuration = 0.3

    // MARK: Layout
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var timeLeftLabel: UILabel!

    // MARK: Properties
    fileprivate var timeDescriptor: TimeDescriptorProtocol!
    fileprivate var scoreDescriptor: ScoreDescriptorProtocol!

    // MARK: View Controller Lifecycle
    /// Presents the information on view after loading.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        redisplayCurrentScore()
        redisplayTimeRemaining()
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
    fileprivate func redisplayCurrentScore() {
        let text = "\(scoreDescriptor.currentScore)"
        setTextAndFlashIfNeeded(text, toLabel: scoreLabel)
    }

    /// Displays the time remaining in the label, in integer.
    fileprivate func redisplayTimeRemaining() {
        let text = "\(Int(round(timeDescriptor.timeRemaining)))"
        setTextAndFlashIfNeeded(text, toLabel: timeLeftLabel)
    }

    /// Helper method to set text and flash label if there is a change in string.
    private func setTextAndFlashIfNeeded(_ text: String, toLabel label: UILabel) {
        guard text != label.text else {
            return
        }
        label.text = text
        flashLabel(label)
    }

    /// Animates effect that highlights the update of the label (e.g. grow shrinking)
    private func flashLabel(_ label: UILabel) {
        let scale = GameStatisticsViewController.flashScale

        label.transform = label.transform.scaledBy(x: scale, y: scale)
        UIView.animate(withDuration: GameStatisticsViewController.flashDuration) {
            label.transform = label.transform.scaledBy(x: 1 / scale, y: 1 / scale)
        }
    }
}

extension GameStatisticsViewController: TimeUpdateDelegate {

    /// Tells the implementor of the delegate that the time has been updated.
    func timeDidUpdate() {
        redisplayTimeRemaining()
    }
}

extension GameStatisticsViewController: ScoreUpdateDelegate {

    /// Tells the implementor of the delegate that the score has been updated.
    func scoreDidUpdate() {
        redisplayCurrentScore()
    }
}
