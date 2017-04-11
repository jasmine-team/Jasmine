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

    var viewModel: LevelDesignerViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setDataFromLevelToEdit()
    }

    /// Set the controls and texts to display based on the level to edit
    private func setDataFromLevelToEdit() {
        guard let gameInfo = viewModel.gameInfo else {
            return
        }
        levelNameField.text = gameInfo.levelName

        guard let gameModeIndex = LevelDesignerViewController.gameModeOrder.index(of: gameInfo.gameMode),
              let gameTypeIndex = LevelDesignerViewController.gameTypeOrder.index(of: gameInfo.gameType) else {
            fatalError("Unable to get game mode/type index")
        }
        gameModeControl.selectedSegmentIndex = gameModeIndex
        gameTypeControl.selectedSegmentIndex = gameTypeIndex

        updateSelectPhrasesButtonText()
    }

    private func updateSelectPhrasesButtonText() {
        let buttonText = String(format: LevelDesignerViewController.selectPhrasesButtonText,
                                viewModel.selectedPhrasesCount)
        selectPhrasesButton.setTitle(buttonText, for: .normal)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let phrasesExplorerViewController = segue.destination as? PhrasesExplorerViewController {
            // TODO : initialize VM and set selected phrases (waiting for Phrases and PhrasesExplorerViewModel update)
        }
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
        let gameMode = LevelDesignerViewController.gameModeOrder[gameModeControl.selectedSegmentIndex]
        let gameType = LevelDesignerViewController.gameTypeOrder[gameTypeControl.selectedSegmentIndex]

        do {
            try viewModel.saveLevel(name: levelNameField.text, gameType: gameType, gameMode: gameMode)
            return true
        } catch LevelsError.duplicateLevelName(let name) {
            showOverwriteAlert(name: name, gameType: gameType, gameMode: gameMode)
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
