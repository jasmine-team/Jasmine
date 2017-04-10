import UIKit

class LevelDesignerViewController: UIViewController {

    @IBOutlet private var levelNameField: UITextField!

    /// The order of the game mode on the gameModeControl
    private static let gameModeOrder: [GameMode] = [.tetris, .sliding, .swapping]
    @IBOutlet private var gameModeControl: UISegmentedControl!

    /// The order of the game type on the gameTypeControl
    private static let gameTypeOrder: [GameType] = [.chengYu, .ciHui]
    @IBOutlet private var gameTypeControl: UISegmentedControl!

    /// The formatted text for the select phrases button, with %d representing the phrases count
    private static let selectPhrasesButtonText = "Select phrases (%d currently)"
    @IBOutlet private var selectPhrasesButton: UIButton!

    /// The levels data to add to or update. To be set by LevelSelectionViewController
    var levels: Levels?
    /// The level under edit. To be set by LevelSelectionViewController
    var levelToEdit: Level?
    /// The phrases that has been selected. To be set to PhrasesExplorerViewModel's phrases
    private var selectedPhrases: Phrases? {
        didSet {
            let buttonText = String(format: LevelDesignerViewController.selectPhrasesButtonText,
                                    selectedPhrases?.count ?? 0)
            selectPhrasesButton.setTitle(buttonText, for: .normal)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDataFromLevelToEdit()
    }

    /// Set the controls and texts to display based on the level to edit
    private func setDataFromLevelToEdit() {
        guard let level = levelToEdit else {
            return
        }
        levelNameField.text = level.name

        guard let gameModeIndex = LevelDesignerViewController.gameModeOrder.index(of: level.gameMode),
              let gameTypeIndex = LevelDesignerViewController.gameTypeOrder.index(of: level.gameType) else {
            fatalError("Unable to get game mode/type index")
        }
        gameModeControl.selectedSegmentIndex = gameModeIndex
        gameTypeControl.selectedSegmentIndex = gameTypeIndex

        selectedPhrases = level.phrases
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let phrasesExplorerViewController = segue.destination as? PhrasesExplorerViewController {
            // TODO : initialize VM and set selected phrases (waiting for Phrases and PhrasesExplorerViewModel update)
        }
    }

    // TODO : wait for level select VC to be implemented and segue to it
    @IBAction private func onSaveAndCloseButtonPressed(_ button: UIButton) {
        saveGame()
    }

    // TODO : create helper for game initialization with the given game mode/type
    @IBAction private func onSaveAndPlayButtonPressed(_ button: UIButton) {
        saveGame()
    }

    // TODO : set phrases for levels call (waiting for Phrases and PhrasesExplorerViewModel update)
    /// Saves the game, default name will be used if no name is given in text field. 
    /// Asks for overwrite if necessary.
    private func saveGame() {
        let gameMode = LevelDesignerViewController.gameModeOrder[gameModeControl.selectedSegmentIndex]
        let gameType = LevelDesignerViewController.gameTypeOrder[gameTypeControl.selectedSegmentIndex]

        do {
            if let levelToEdit = levelToEdit {
                try levels?.deleteLevel(levelToEdit)
            }
            try levels?.addCustomLevel(name: levelNameField.text, gameType: gameType, gameMode: gameMode, phrases: [])
        } catch LevelsError.duplicateLevelName(let name) {
            showOverwriteAlert(name: name, gameType: gameType, gameMode: gameMode, phrases: [])
        } catch {
            showError(error)
        }
    }

    /// Shows an overwrite alert. If overwrite is selected, level with name `name` will be overwritten
    ///
    /// - Parameters:
    ///   - name: the level name to overwrite
    ///   - gameType: the updated GameType
    ///   - gameMode: the updated GameMode
    ///   - phrases: the updated phrases
    private func showOverwriteAlert(name: String, gameType: GameType, gameMode: GameMode, phrases: [Phrase]) {
        let levelNameExistsAlert = getAlertControllerWithCancel(title: "Level name already exists")
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .destructive) { _ in
            do {
                try self.levels?.updateCustomLevel(name: name, gameType: gameType, gameMode: gameMode, phrases: [])
            } catch {
                self.showError(error)
            }
        }
        levelNameExistsAlert.addAction(overwriteAction)
        present(levelNameExistsAlert, animated: true)
    }
}
