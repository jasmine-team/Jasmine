import UIKit

class LevelSelectorViewController: UIViewController {

    // MARK: Constants
    fileprivate static let segueToGameIdentifier: [GameMode: String] = [
        .sliding: "SegueToSlidingGame", .swapping: "SegueToSwappingGame", .tetris: "SegueToTetrisGame"
    ]

    fileprivate static let segueToPhrasesExplorer = "SegueToPhrasesExplorer"
    fileprivate static let segueToLevelDesigner = "SegueToLevelDesigner"

    private static let actionSheetEdit = "Edit Level"
    private static let actionSheetPhrases = "View Phrases"
    private static let actionSheetDelete = "Delete Level"
    private static let actionSheetCancel = "Cancel"

    // MARK: Layouts
    fileprivate var levelCollection: GameLevelListViewController!

    // MARK: Properties
    /// Provides a view model for this view. By default a full LevelSelectorViewModel is used in this
    /// case. Dependency injection can be attained by calling `segueWith(...)`.
    fileprivate lazy var viewModel: LevelSelectorViewModelProtocol = {
        let viewModel = LevelSelectorViewModel()
        viewModel.delegate = self
        return viewModel
    }()

    fileprivate var selectedLevel: GameInfo!

    // MARK: View Controller Lifecycle
    /// Override method that helps to segue into the appropriate views.
    /// - Postcondition: The `selectedLevel` property will be cleared after execution.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let levelCollection = segue.destination as? GameLevelListViewController {
            self.levelCollection = levelCollection
            self.levelCollection.segueWith(delegate: self)

        } else if let swappingGameView = segue.destination as? SwappingGameViewController {
            guard let swappingViewModel = viewModel
                      .playGame(from: selectedLevel) as? SwappingViewModelProtocol else {
                assertionFailure("Incorrect view model provided to Swapping VC.")
                return
            }
            swappingGameView.segueWith(swappingViewModel)

        } else if let slidingGameView = segue.destination as? SlidingGameViewController {
            guard let slidingViewModel = viewModel
                      .playGame(from: selectedLevel) as? SlidingViewModelProtocol else {
                assertionFailure("Incorrect view model provided to Sliding VC.")
                return
            }
            slidingGameView.segueWith(slidingViewModel)

        } else if let tetrisGameView = segue.destination as? TetrisGameViewController {
            guard let tetrisViewModel = viewModel
                      .playGame(from: selectedLevel) as? TetrisGameViewModelProtocol else {
                assertionFailure("Incorrect view model provided to Tetris VC.")
                return
            }
            tetrisGameView.segueWith(tetrisViewModel)

        } else if let phrasesExplorerView = segue.destination as? PhrasesExplorerViewController {
            let phrasesExplorerViewModel = viewModel.getPhraseExplorerViewModel(from: selectedLevel)
            phrasesExplorerView.segueWith(phrasesExplorerViewModel, isMarkable: false)

        } else if let levelDesignerView = segue.destination as? LevelDesignerViewController {
            // let levelDesignerViewModel = LevelDesignerViewModel(levels: <#T##Levels#>)
        }

        self.selectedLevel = nil
    }

    /// Segues into this view with the appropriate data specified below.
    ///
    /// - Parameter viewModel: the view model of this view controller class.
    func segueWith(_ viewModel: LevelSelectorViewModelProtocol) {
        self.viewModel = viewModel
        self.viewModel.delegate = self
    }

    fileprivate func segueToEditLevelView(forLevel level: GameInfo) {
        self.selectedLevel = level
        performSegue(withIdentifier: LevelSelectorViewController.segueToLevelDesigner, sender: nil)
    }

    fileprivate func segueToPhrasesExplorerView(forLevel level: GameInfo) {
        self.selectedLevel = level
        performSegue(withIdentifier: LevelSelectorViewController.segueToPhrasesExplorer, sender: nil)
    }

    // MARK: Helper Method
    /// Helper method that returns the appropriate level (default or custom) depending on
    /// `isDefaultLevels`.
    fileprivate func getLevels(fromDefault isDefaultLevels: Bool) -> [GameInfo] {
        return isDefaultLevels ? viewModel.defaultLevels
                               : viewModel.customLevels
    }

    /// Builds an actionsheet depending on the type of level being fed.
    fileprivate func buildActionSheet(forLevel level: GameInfo, andView view: UIView) -> UIAlertController {
        let actionSheetController = UIAlertController(title: level.levelName, message: nil,
                                                      preferredStyle: .actionSheet)

        let phrasesAction = UIAlertAction(
            title: LevelSelectorViewController.actionSheetPhrases, style: .default) { _ in
                self.segueToPhrasesExplorerView(forLevel: level)
        }
        actionSheetController.addAction(phrasesAction)

        if level.isEditable {
            let editAction = UIAlertAction(
                title: LevelSelectorViewController.actionSheetEdit, style: .default) { _ in
                    self.segueToEditLevelView(forLevel: level)
            }
            actionSheetController.addAction(editAction)
        }

        if level.isEditable {
            let deleteAction = UIAlertAction(
                title: LevelSelectorViewController.actionSheetDelete, style: .destructive) { _ in
                    self.viewModel.deleteLevel(from: level)
            }
            actionSheetController.addAction(deleteAction)
        }

        let cancelAction = UIAlertAction(
            title: LevelSelectorViewController.actionSheetCancel, style: .cancel, handler: nil)
        actionSheetController.addAction(cancelAction)

        actionSheetController.popoverPresentationController?.sourceView = view
        return actionSheetController
    }
}

extension LevelSelectorViewController: GameLevelListViewDelegate {

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
    /// In this view controller, should always return false.
    func shouldMarkAsSelected(fromDefault isDefaultLevels: Bool, at index: Int) -> Bool {
        return false
    }

    /// Notifies the user of this view controller that a level has been selected.
    func notifyLevelSelected(fromDefault isDefaultLevels: Bool, at index: Int) {
        self.selectedLevel = getLevels(fromDefault: isDefaultLevels)[index]
        guard let segueIdentifier = LevelSelectorViewController
                  .segueToGameIdentifier[selectedLevel.gameMode] else {
            return
        }
        self.performSegue(withIdentifier: segueIdentifier, sender: nil)
    }

    /// Notifies the user of this view controller to open the list of menu for the specified level.
    func notifyOpenMenuForLevel(fromDefault isDefaultLevels: Bool, at index: Int, withView view: UIView) {
        self.selectedLevel = getLevels(fromDefault: isDefaultLevels)[index]
        let actionSheet = buildActionSheet(forLevel: selectedLevel, andView: view)
        self.present(actionSheet, animated: true, completion: nil)
    }
}

extension LevelSelectorViewController: LevelSelectorViewControllerDelegate {
    /// Reload the level at the given index.
    ///
    /// - Parameter index: the index for the level to be reloaded
    /// - Parameter isDefault: whether the level is default or not
    func reloadLevel(at index: Int, isDefault: Bool) {
        levelCollection.reloadData(fromDefault: isDefault, at: index)
    }

    /// Reload all levels.
    func reloadAllLevels() {
        levelCollection.reloadAllData()
    }
}
