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

    // TODO: Delete this away when SquareGridVC does not store grid data.
    fileprivate var displayedPhases: [Phrase]!

    // MARK: - Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let testedPhrase = segue.destination as? SelectableSquareGridViewController {

            displayedPhases = Array(gameDesriptor.phrasesTested)
            let phrasesString = TextGrid(fromInitialCol: displayedPhases.map { $0.chinese.joined() })
            testedPhrase.segueScrollableWith(phrasesString,
                                             withSpace: GameOverViewController.tileSpace,
                                             customSize: GameOverViewController.tileSize)

            testedPhrase.onTileSelected = segueToPhrase(at:)
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
        self.presentingViewController?.presentingViewController?
            .dismiss(animated: true, completion: nil)
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
            assertionFailure("Game must be concluded in order to view this screen.")
        }
    }

    /// Opens the definition to the phrase
    private func segueToPhrase(at coord: Coordinate) {
        // TODO: Complete this.
        let index = coord.row
        print(displayedPhases[index])
    }
}
