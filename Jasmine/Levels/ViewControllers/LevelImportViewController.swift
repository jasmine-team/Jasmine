import UIKit

class LevelImportViewController: UIViewController {

    // MARK: Constants
    private static let actionSheetPhrases = "View Phrases"
    private static let actionSheetCancel = "Cancel"

    fileprivate static let segueToPhrasesExplorer = "SegueToPhrasesExplorer"

    // MARK: Layouts
    fileprivate var levelCollectionView: GameLevelListViewController!

    // MARK: Properties
    fileprivate var viewModel: LevelImportViewModelProtocol!

    fileprivate var selectedLevelRow: Int!
    fileprivate var selectedLevelIsDefault: Bool!

    // MARK: Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let levelCollectionView = segue.destination as? GameLevelListViewController {
            self.levelCollectionView = levelCollectionView
            self.levelCollectionView.segueWith(delegate: self)

        } else if let phrasesExplorerView = segue.destination as? PhrasesExplorerViewController {
            let phrasesExplorerViewModel = viewModel.getPhraseExplorerViewModel(fromRow: selectedLevelRow,
                                                                                isDefault: selectedLevelIsDefault)
            phrasesExplorerView.segueWith(phrasesExplorerViewModel)
        }
    }

    /// Opens this view controller by injecting this view model protocol
    func segueWith(_ viewModel: LevelImportViewModelProtocol,
                   onMarkedLevelsReturned callback: (([GameInfo]) -> Void)?) {
        self.viewModel = viewModel
        self.onMarkedLevelsReturned = callback
    }

    fileprivate func segueToPhrasesExplorerView(forLevelRow row: Int, isDefault: Bool) {
        selectedLevelRow = row
        selectedLevelIsDefault = isDefault
        performSegue(withIdentifier: LevelImportViewController.segueToPhrasesExplorer, sender: nil)
    }

    // MARK: Listeners
    /// Implements this listener to return a set of levels that are marked (or selected) with this view.
    var onMarkedLevelsReturned: (([GameInfo]) -> Void)?

    @IBAction private func onBackPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }

    @IBAction private func onDonePressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true) {
            self.onMarkedLevelsReturned?(self.viewModel.markedLevels)
        }
    }

    // MARK: Helper Methods
    /// Helper method that returns the appropriate level (default or custom) depending on
    /// `isDefaultLevels`.
    fileprivate func getLevels(fromDefault isDefaultLevels: Bool) -> [GameInfo] {
        return isDefaultLevels ? viewModel.defaultLevels
                               : viewModel.customLevels
    }

    /// Builds an actionsheet depending on the type of level being fed.
    fileprivate func buildActionSheet(fromDefault isDefaultLevel: Bool, at index: Int,
                                      withView view: UIView) -> UIAlertController {
        let level = getLevel(fromDefault: isDefaultLevel, at: index)
        let actionSheetController = UIAlertController(title: level.levelName, message: nil,
                                                      preferredStyle: .actionSheet)
        let phrasesAction = UIAlertAction(title: LevelImportViewController.actionSheetPhrases,
                                          style: .default) { _ in
            self.segueToPhrasesExplorerView(forLevelRow: index, isDefault: isDefaultLevel)
        }
        actionSheetController.addAction(phrasesAction)

        let cancelAction = UIAlertAction(title: LevelImportViewController.actionSheetCancel,
                                         style: .cancel)
        actionSheetController.addAction(cancelAction)

        actionSheetController.popoverPresentationController?.sourceView = view
        return actionSheetController
    }
}

extension LevelImportViewController: GameLevelListViewDelegate {
    /// Gets the number of levels.
    ///
    /// - Parameter isDefaultLevels: true if number of levels from default, false from custom.
    /// - Returns: the number of levels.
    func getNumberOfLevels(fromDefault isDefaultLevels: Bool) -> Int {
        return getLevels(fromDefault: isDefaultLevels).count
    }

    /// Gets a specific level data from the specific index in an ordered list.
    ///
    /// - Parameter isDefaultLevels: true if levels from default, false from custom.
    /// - Returns: the specific level data from the specified index.
    /// - Precondition: index should range from 0 to `getNumberOfLevels`.
    func getLevel(fromDefault isDefaultLevels: Bool, at index: Int) -> GameInfo {
        return getLevels(fromDefault: isDefaultLevels)[index]
    }

    /// Asks the user of this view controller if the level should be mark as selected.
    func shouldMarkAsSelected(fromDefault isDefaultLevels: Bool, at index: Int) -> Bool {
        return viewModel.isLevelMarked(fromRow: index, isDefault: isDefaultLevels)
    }

    /// Notifies the user of this view controller that a level has been selected.
    func notifyLevelSelected(fromDefault isDefaultLevels: Bool, at index: Int) {
        let shouldMark = viewModel.toggleLevelMarked(fromRow: index, isDefault: isDefaultLevels)
        levelCollectionView.markLevel(fromDefault: isDefaultLevels, at: index, asSelected: shouldMark)
    }

    /// Notifies the user of this view controller to open the list of menu for the specified level.
    func notifyOpenMenuForLevel(fromDefault isDefaultLevels: Bool, at index: Int, withView view: UIView) {
        let actionSheet = buildActionSheet(fromDefault: isDefaultLevels, at: index, withView: view)
        self.present(actionSheet, animated: true)
    }
}
