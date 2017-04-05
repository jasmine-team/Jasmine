import UIKit

class GameOverViewController: UIViewController {

    // MARK: - Constants
    private static let tileSpace: CGFloat = 8.0
    private static let tileSize = CGSize(width: 232, height: 80)

    // MARK: - Layouts
    @IBOutlet fileprivate weak var scoreLabel: UILabel!
    @IBOutlet fileprivate weak var gameOverTitle: UILabel!
    @IBOutlet fileprivate weak var gameOverSubtitle: UILabel!
    @IBOutlet fileprivate weak var navigationBar: UINavigationBar!

    fileprivate var testedPhrasesView: SquareGridViewController!

    // MARK: - Properties
    fileprivate var gameDesriptor: GameDescriptorProtocol!

    // MARK: - Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let testedPhrase = segue.destination as? SquareGridViewController {
            let phrasesString = TextGrid(
                fromInitialCol: gameDesriptor.phrasesTested.map { $0.chinese })
            testedPhrase.segueWith(phrasesString,
                                   withSpace: GameOverViewController.tileSpace,
                                   customSize: GameOverViewController.tileSize)
        }
    }

    /// Segue with the required information
    ///
    /// - Parameter gameDescriptor: a view model that describes the game that was just played.
    func segueWith(_ gameDescriptor: GameDescriptorProtocol) {
        self.gameDesriptor = gameDescriptor
    }

    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        loadGameDescriptionsToUi()
    }

    /// Dismisses this view controller, and the previous game view controller.
    @IBAction func onBackPressed(_ sender: UIBarButtonItem) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    // MARK: - Helper Methods
    private func loadGameDescriptionsToUi() {
        self.navigationBar.topItem?.title = gameDesriptor.gameTitle
        self.scoreLabel.text = "\(gameDesriptor.currentScore)"

        if gameDesriptor.gameStatus == .endedWithWon {
            self.gameOverTitle.text = Constants.Game.GameOver.titleWin
            self.gameOverSubtitle.text = Constants.Game.GameOver.subtitleWin

        } else if gameDesriptor.gameStatus == .endedWithLost {
            self.gameOverTitle.text = Constants.Game.GameOver.titleLose
            self.gameOverSubtitle.text = Constants.Game.GameOver.subtitleLose

        } else {
            // TODO: assertionFailure("Game must be concluded in order to view this screen.")
        }
    }
}
