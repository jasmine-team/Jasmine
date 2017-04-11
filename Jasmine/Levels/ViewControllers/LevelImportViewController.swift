import UIKit

class LevelImportViewController: UIViewController {

    // MARK: Constants
    private static let actionSheetPhrases = "View Phrases"

    // MARK: Layouts
    fileprivate var levelCollectionView: GameLevelListViewController!

    // MARK: Properties
    fileprivate var viewModel: LevelImportViewModelProtocol!

    fileprivate var selectedLevel: GameInfo!

    // MARK: Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let levelCollectionView = segue.destination as? GameLevelListViewController {
            self.levelCollectionView = levelCollectionView
            self.levelCollectionView.segueWith(delegate: self)

        } else if let phrasesExplorerView = segue.destination as? PhrasesExplorerViewController {
            let phrasesExplorerViewModel = viewModel.getPhraseExplorerViewModel(from: selectedLevel)
            phrasesExplorerView.segueWith(phrasesExplorerViewModel)
        }
    }

    /// Opens this view controller by injecting this view model protocol
    func segueWith(_ viewModel: LevelImportViewModelProtocol) {
        self.viewModel = viewModel
    }

    // MARK: Helper Methods
    /// Helper method that returns the appropriate level (default or custom) depending on
    /// `isDefaultLevels`.
    fileprivate func getLevels(fromDefault isDefaultLevels: Bool) -> [GameInfo] {
        return isDefaultLevels ? viewModel.defaultLevels
                               : viewModel.customLevels
    }

    /// Builds an actionsheet depending on the type of level being fed.
    fileprivate func buildActionSheet(forLevel level: GameInfo) -> UIAlertController {
        let actionSheetController = UIAlertController(title: level.levelName, message: nil,
                                                      preferredStyle: .actionSheet)
        let phrasesAction = UIAlertAction(
        title: LevelImportViewController.actionSheetPhrases, style: .default) { _ in
            self.segueToPhrasesExplorerView(forLevel: level)
        }
        actionSheetController.addAction(phrasesAction)
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
        let level = getLevels(fromDefault: isDefaultLevels)[index]
        return viewModel.isLevelMarked(for: level)
    }

    /// Notifies the user of this view controller that a level has been selected.
    func notifyLevelSelected(fromDefault isDefaultLevels: Bool, at index: Int) {
        selectedLevel = getLevels(fromDefault: isDefaultLevels)[index]
        let shouldMark = viewModel.toggleLevelMarked(for: selectedLevel)
        levelCollectionView.markLevel(fromDefault: isDefaultLevels, at: index, asSelected: shouldMark)
    }

    /// Notifies the user of this view controller to open the list of menu for the specified level.
    func notifyOpenMenuForLevel(fromDefault isDefaultLevels: Bool, at index: Int) {
        selectedLevel = getLevels(fromDefault: isDefaultLevels)[index]
        let actionSheet = buildActionSheet(forLevel: selectedLevel)
        self.present(actionSheet, animated: true, completion: nil)
    }
}
