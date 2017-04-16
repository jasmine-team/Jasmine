import UIKit

class GameOverViewController: JasmineViewController {

    // MARK: - Constants
    private static let viewTitle = "Game Results"

    private static let tileSpace: CGFloat = 8.0
    private static let tileSize = CGSize(width: 232, height: 80)
    private static let segueToPhraseView = "PhraseViewController"

    // MARK: - Layouts
    @IBOutlet fileprivate weak var scoreLabel: UILabel!
    @IBOutlet fileprivate weak var gameOverTitle: UILabel!
    @IBOutlet fileprivate weak var gameOverSubtitle: UILabel!
    @IBOutlet fileprivate weak var navigationBar: UINavigationBar!

    fileprivate var testedPhrasesView: SquareGridViewController!

    // MARK: - Properties
    fileprivate var gameDesriptor: GameDescriptorProtocol!

    fileprivate var displayedPhases: [Phrase]!

    private var selectedPhrase: Phrase!

    // MARK: - Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let testedPhrase = segue.destination as? SelectableSquareGridViewController {

            displayedPhases = Array(gameDesriptor.phrasesTested)
            let phrasesString = TextGrid(fromInitialCol: displayedPhases.map { $0.chinese.joined() })
            testedPhrase.segueScrollableWith(phrasesString,
                                             withSpace: GameOverViewController.tileSpace,
                                             customSize: GameOverViewController.tileSize)

            testedPhrase.onTileSelected = segueToPhrase(at:)

        } else if let phraseView = segue.destination as? PhraseViewController {
            phraseView.segueWith(PhraseViewModel(phrase: selectedPhrase))
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
        super.viewDidLoad()
        super.setLayout(navigationBar: navigationBar,
                        withTitle: GameOverViewController.viewTitle)

        loadGameDescriptionsToUi()
    }

    // MARK: - Override methods
    /// Dismisses this view controller, and the previous game view controller.
    override func onDismissPressed() {
        self.presentingViewController?.presentingViewController?
            .dismiss(animated: true)
    }

    // MARK: - Helper Methods
    private func loadGameDescriptionsToUi() {
        self.navigationBar.topItem?.title = gameDesriptor.levelName
        self.scoreLabel.text = "\(gameDesriptor.currentScore)"

        if gameDesriptor.gameStatus == .endedWithWon {
            self.gameOverTitle.text = GameConstants.GameOver.titleWin
            self.gameOverSubtitle.text = GameConstants.GameOver.subtitleWin

        } else if gameDesriptor.gameStatus == .endedWithLost {
            self.gameOverTitle.text = GameConstants.GameOver.titleLose
            self.gameOverSubtitle.text = GameConstants.GameOver.subtitleLose

        } else {
            assertionFailure("Game must be concluded in order to view this screen.")
        }
    }

    /// Opens the definition to the phrase
    private func segueToPhrase(at coord: Coordinate) {
        let index = coord.row
        selectedPhrase = displayedPhases[index]
        performSegue(withIdentifier: GameOverViewController.segueToPhraseView, sender: nil)
    }
}
