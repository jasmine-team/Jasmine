import UIKit

class LevelSelectionViewController: UIViewController {

    // MARK: Constants
    fileprivate static let segueToGameIdentifier: [GameMode: String] = [
        .sliding: "SegueToSlidingGame", .swapping: "SegueToSwappingGame", .tetris: "SegueToTetrisGame"
    ]

    // MARK: Layouts
    fileprivate var levelCollection: GameLevelListViewController!

    // MARK: Properties
    fileprivate var viewModel: LevelSelectorViewModelProtocol!

    fileprivate var selectedLevel: GameInfo!

    // MARK: View Controller Lifecycle
    /// Override method that helps to segue into the appropriate views.
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
        }
    }

    /// Segues into this view with the appropriate data specified below.
    ///
    /// - Parameter viewModel: the view model of this view controller class.
    func segueWith(_ viewModel: LevelSelectorViewModelProtocol) {
        self.viewModel = viewModel
    }

    // MARK: Helper Method
    /// Helper method that returns the appropriate level (default or custom) depending on
    /// `isDefaultLevels`.
    fileprivate func getLevels(fromDefault isDefaultLevels: Bool) -> [GameInfo] {
        return isDefaultLevels ? viewModel.defaultLevels
                               : viewModel.customLevels
    }
}

extension LevelSelectionViewController: GameLevelListViewDelegate {

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
    func notifyLevelSelected(fromDefault isDefaultLevels: Bool, at index: Int,
                             withCell levelCell: GameLevelViewCell) {

        self.selectedLevel = getLevels(fromDefault: isDefaultLevels)[index]
        self.performSegue(withIdentifier: LevelSelectionViewController
            .segueToGameIdentifier[selectedLevel.gameMode], sender: nil)
    }

    /// Notifies the user of this view controller to open the list of menu for the specified level.
    func notifyOpenMenuForLevel(fromDefault isDefaultLevels: Bool, at index: Int) {

    }
}

extension LevelSelectionViewController: LevelSelectorViewControllerDelegate {
    /// Reload the level at the given index.
    ///
    /// - Parameter index: the index for the level to be reloaded
    /// - Parameter isDefault: whether the level is default or not
    func reloadLevel(at index: Int, isDefault: Bool) {

    }

    /// Reload all levels.
    func reloadAllLevels() {
        levelCollection.reloadAllData()
    }
}
