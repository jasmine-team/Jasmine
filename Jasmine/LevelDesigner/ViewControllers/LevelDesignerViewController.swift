import UIKit

class LevelDesignerViewController: JasmineViewController {

    @IBOutlet private var levelNameField: UITextField!

    @IBOutlet private var gameModeControl: UISegmentedControl!
    @IBOutlet private var gameTypeControl: UISegmentedControl!
    @IBOutlet private weak var navigationBar: UINavigationBar!

    /// The order of the game mode on the gameModeControl
    private static let gameModeOrder: [GameMode] = [.tetris, .sliding, .swapping]
    /// The order of the game type on the gameTypeControl
    private static let gameTypeOrder: [GameType] = [.chengYu, .ciHui]

    /// Gets the currently selected game mode
    var selectedGameMode: GameMode {
        return LevelDesignerViewController.gameModeOrder[gameModeControl.selectedSegmentIndex]
    }
    /// Gets the currently selected game type
    var selectedGameType: GameType {
        return LevelDesignerViewController.gameTypeOrder[gameTypeControl.selectedSegmentIndex]
    }

    /// The formatted text for the select phrases button, with %d representing the phrases count
    private static let selectPhrasesButtonText = "SELECT PHRASES (%d)"
    @IBOutlet private var selectPhrasesButton: UIButton!

    /// Title of the alert to show when saving to an existing level name
    private static let levelNameExistsAlertTitle = "Level name already exists"
    /// Text for the overwrite action when asking to overwrite an existing level name
    private static let overwriteActionText = "Overwrite"

    private var viewModel: LevelDesignerViewModel!
    private var onSaveCallBack: (() -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()
        super.setLayout(navigationBar: navigationBar)

        setDataFromLevelToEdit()
        updateSelectPhrasesButtonText()
    }

    /// Feeds in the appropriate data for the use of seguing into this view.
    ///
    /// - Parameters:
    ///   - viewModel: the level designer view model required to use this view
    ///   - onSaveCallBack: Callback to be executed after saving
    func segueWith(_ viewModel: LevelDesignerViewModel, onSaveCallBack: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onSaveCallBack = onSaveCallBack
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let phrasesExplorerViewController = segue.destination as? PhrasesExplorerViewController {
            let phrasesExplorerViewModel = PhrasesExplorerViewModel(phrases: phrasesForSelectedGameType,
                                               selectedPhrases: viewModel.selectedPhrases[selectedGameType])
            phrasesExplorerViewController.segueWith(phrasesExplorerViewModel, onSaveCallBack: updateSelectedPhrases)

        } else if let levelImporterView = segue.destination as? LevelImportViewController {
            levelImporterView.segueWith(LevelImportViewModel(withType: selectedGameType),
                                        onMarkedLevelsReturned: onLevelsImported)
        }
    }

    /// Updates the selected phrases for the currently selected game type with `phrases` retrieved from phrase explorer
    ///
    /// - Parameter phrases: the selected phrases to update to
    private func updateSelectedPhrases(_ phrases: Set<Phrase>) {
        viewModel.selectedPhrases[selectedGameType] = phrases
        updateSelectPhrasesButtonText()
    }

    /// Set the controls and texts to display based on the level to edit
    private func setDataFromLevelToEdit() {
        guard let levelInEditInfo = viewModel.levelInEditInfo else {
            return
        }
        levelNameField.text = levelInEditInfo.levelName

        guard let gameModeIndex = LevelDesignerViewController.gameModeOrder.index(of: levelInEditInfo.gameMode),
              let gameTypeIndex = LevelDesignerViewController.gameTypeOrder.index(of: levelInEditInfo.gameType) else {
            fatalError("Unable to get game mode/type index")
        }
        gameModeControl.selectedSegmentIndex = gameModeIndex
        gameTypeControl.selectedSegmentIndex = gameTypeIndex
    }

    /// Updates the select phrases button text based on the phrases count for the currently selected game type
    private func updateSelectPhrasesButtonText() {
        let buttonText = String(format: LevelDesignerViewController.selectPhrasesButtonText,
                                viewModel.getSelectedPhrasesCount(gameType: selectedGameType))
        selectPhrasesButton.setTitle(buttonText, for: .normal)
    }

    /// Returns all the phrases in the database for the selected game type
    private var phrasesForSelectedGameType: Phrases {
        switch selectedGameType {
        case .chengYu:
            return Storage.sharedInstance.allChengYu
        case .ciHui:
            return Storage.sharedInstance.allCiHui
        }
    }

    @IBAction private func onGameTypeControlPressed(_ segmentedControl: UISegmentedControl) {
        updateSelectPhrasesButtonText()
    }

    /// Saves the game and dismiss the view if successfully saved
    @IBAction private func onSaveButtonPressed(_ sender: UIBarButtonItem) {
        if saveLevel() {
            onSaveCallBack()
            dismiss(animated: true)
        }
    }

    /// Warns the user if they want to leave without saving, dismiss the view if conformed
    override func onDismissPressed() {
        showExitWithoutSavingAlert()
    }

    /// Saves the imported levels to selected phrases
    ///
    /// - Parameter levels: levels that have been imported
    /// - Precondition: `levels` must all have the same game type as the currently selected game type
    private func onLevelsImported(_ levels: [GameInfo]) {
        assert(levels.first { $0.gameType != selectedGameType } == nil,
               "Imported levels are not of the same game type as selected game type")
        viewModel.addToSelectedPhrases(from: levels)
        updateSelectPhrasesButtonText()
    }

    /// Saves the game, default name will be used if no name is given in text field. 
    /// Asks for overwrite if necessary.
    ///
    /// - Returns: true if successfully saved
    private func saveLevel() -> Bool {
        do {
            try viewModel.saveLevel(name: levelNameField.text, gameType: selectedGameType, gameMode: selectedGameMode)
            return true
        } catch LevelsError.duplicateLevelName(let name) {
            showOverwriteAlert(name: name, gameType: selectedGameType, gameMode: selectedGameMode)
        } catch {
            showError(error)
        }
        return false
    }

    /// Shows an overwrite alert. If overwrite is selected, level with name `name` will be overwritten
    ///
    /// - Parameters:
    ///   - name: the level name to overwrite
    ///   - gameType: the updated GameType
    ///   - gameMode: the updated GameMode
    private func showOverwriteAlert(name: String, gameType: GameType, gameMode: GameMode) {
        showAlert(title: LevelDesignerViewController.levelNameExistsAlertTitle,
                  actionText: LevelDesignerViewController.overwriteActionText) {
            do {
                try self.viewModel.updateCustomLevel(name: name, gameType: gameType, gameMode: gameMode)
                self.dismiss(animated: true)
            } catch {
                self.showError(error)
            }
        }
    }
}
