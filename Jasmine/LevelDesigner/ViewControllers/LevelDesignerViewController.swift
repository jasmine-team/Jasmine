import UIKit

class LevelDesignerViewController: UIViewController {

    @IBOutlet private var levelNameField: UITextField!

    @IBOutlet private var gameModeControl: UISegmentedControl!
    @IBOutlet private var gameTypeControl: UISegmentedControl!

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

    private var viewModel: LevelDesignerViewModel!

    /// Feeds in the appropriate data for the use of seguing into this view.
    ///
    /// - Parameter viewModel: the level designer view model required to use this view
    func segueWith(_ viewModel: LevelDesignerViewModel) {
        self.viewModel = viewModel
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setDataFromLevelToEdit()
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

        updateSelectPhrasesButtonText()
    }

    /// Updates the select phrases button text based on the phrases count for the currently selected game type
    private func updateSelectPhrasesButtonText() {
        let buttonText = String(format: LevelDesignerViewController.selectPhrasesButtonText,
                                viewModel.getSelectedPhrasesCount(gameType: selectedGameType))
        selectPhrasesButton.setTitle(buttonText, for: .normal)
    }

    func done(_ phrases: [Phrase]) {
        viewModel.selectedPhrases[selectedGameType] = phrases
        updateSelectPhrasesButtonText()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let phrasesExplorerViewController = segue.destination as? PhrasesExplorerViewController {

            // TODO: refactor this to VM

            let phrases = (selectedGameType == .chengYu) ? Storage.sharedInstance.allChengYu :
                Storage.sharedInstance.allCiHui

            let phrasesExplorerViewModel = PhrasesExplorerViewModel(phrases: phrases,
                                               selectedPhrases: viewModel.selectedPhrases[selectedGameType])
            phrasesExplorerViewController.segueWith(phrasesExplorerViewModel, isMarkable: true, viewController: self)

        }
    }

    @IBAction private func onGameTypeControlPressed(_ segmentedControl: UISegmentedControl) {
        updateSelectPhrasesButtonText()
    }

    /// Saves the game and dismiss the view if successfully saved
    @IBAction private func onSaveButtonPressed(_ sender: UIBarButtonItem) {
        if saveLevel() {
            dismiss(animated: true)
        }
    }

    /// Warns the user if they want to leave without saving, dismiss the view if conformed
    @IBAction private func onBackButtonPressed(_ sender: UIBarButtonItem) {
        let leaveWithoutSavingAlert = getAlertControllerWithCancel(title: "Leave without saving?")
        let conformLeaveAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            self.dismiss(animated: true)
        }
        leaveWithoutSavingAlert.addAction(conformLeaveAction)
        present(leaveWithoutSavingAlert, animated: true)
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
            print("errpr")
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
        let levelNameExistsAlert = getAlertControllerWithCancel(title: "Level name already exists")
        let overwriteAction = UIAlertAction(title: "Overwrite", style: .destructive) { _ in
            do {
                try self.viewModel.updateCustomLevel(name: name, gameType: gameType, gameMode: gameMode)
            } catch {
                self.showError(error)
            }
        }
        levelNameExistsAlert.addAction(overwriteAction)
        present(levelNameExistsAlert, animated: true)
    }
}
