import UIKit

class GameLevelListViewController: UIViewController {

    // MARK: Constants
    fileprivate static let cellIdentifier = "GameLevelViewCell"

    private static let builtInLevelsIndex = 0
    private static let customLevelsIndex = 1

    fileprivate static let cellHeight: CGFloat = 74
    fileprivate static let maxCellWidth: CGFloat = 360

    // MARK: Layout
    @IBOutlet private weak var levelsCategoriesToggle: UISegmentedControl!

    @IBOutlet fileprivate weak var gameLevelListCollection: UICollectionView!

    // MARK: Properties
    /// Specifies a delegate to read the data from.
    weak var delegate: GameLevelListViewDelegate?

    /// Returns true if default levels should be shown.
    var isShowingDefaultLevels: Bool {
        get {
            return levelsCategoriesToggle.selectedSegmentIndex
                == GameLevelListViewController.builtInLevelsIndex
        }
        set {
            levelsCategoriesToggle.selectedSegmentIndex
                = newValue ? GameLevelListViewController.builtInLevelsIndex
                           : GameLevelListViewController.customLevelsIndex
        }
    }

    /// Gets all the indices displayed in this view.
    private var allIndices: Set<IndexPath> {
        let numItems = delegate?.getNumberOfLevels(fromDefault: isShowingDefaultLevels) ?? 0
        return Set((0..<numItems).map { IndexPath(item: $0, section: 0) })
    }

    fileprivate lazy var cellSize: CGSize = {
        let width = min(self.gameLevelListCollection.bounds.width,
                        GameLevelListViewController.maxCellWidth)
        let height = GameLevelListViewController.cellHeight
        return CGSize(width: width, height: height)
    }()

    // MARK: Segue Methods
    /// Supply this view with a data delegate.
    func segueWith(delegate: GameLevelListViewDelegate) {
        self.delegate = delegate
    }

    // MARK: Gestures and Listeners
    /// Updates the level categories based on what has been toggled in the view.
    @IBAction private func onLevelsCategoriesSwitched() {
        reloadAllData()
    }

    /// Notifies that a level has been selected.
    @IBAction private func onLevelSelected(_ sender: UITapGestureRecognizer) {
        let tappedLocation = sender.location(in: gameLevelListCollection)
        guard let indexPath = gameLevelListCollection.indexPathForItem(at: tappedLocation) else {
            return
        }
        delegate?.notifyLevelSelected(fromDefault: isShowingDefaultLevels, at: indexPath.item)
    }

    /// Notifies that the menu of a particular level has been opened.
    @IBAction func onLevelMenuSelected(_ sender: UIButton) {
        let tappedLocation = sender.convert(sender.bounds.center, to: gameLevelListCollection)
        guard let indexPath = gameLevelListCollection.indexPathForItem(at: tappedLocation) else {
            return
        }
        delegate?.notifyOpenMenuForLevel(fromDefault: isShowingDefaultLevels, at: indexPath.item,
                                         withView: sender)
    }

    // MARK: Interfacing Methods
    /// Reloads all the data in this view.
    func reloadAllData() {
        gameLevelListCollection.reloadSections(IndexSet(integer: 0))
    }

    /// Reloads data at the specified index.
    func reloadData(fromDefault isDefault: Bool, at index: Int) {
        guard isShowingDefaultLevels == isDefault else {
            return
        }
        helperReloadLevels(at: [IndexPath(item: index, section: 0)])
    }

    /// Marks a level by placing a tick next to the level cell.
    ///
    /// - Parameters:
    ///   - isDefault: the level comes from default levels, or custom levels
    ///   - index: the index of the level that should be marked.
    ///   - isSelected: set as true to place a tick, false otherwise.
    func markLevel(fromDefault isDefault: Bool, at index: Int, asSelected isSelected: Bool) {
        guard isShowingDefaultLevels == isDefault else {
            return
        }
        guard let cell = gameLevelListCollection
            .cellForItem(at: IndexPath(item: index, section: 0)) as? GameLevelViewCell else {
            return
        }
        cell.isMarked = isSelected
    }

    // MARK: Helper Methods
    private func helperReloadLevels(at indices: Set<IndexPath>) {
        self.gameLevelListCollection.reloadItems(at: Array(indices))
    }
}

// MARK: - Data Source
extension GameLevelListViewController: UICollectionViewDataSource {

    /// Feed in the number of levels to display.
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return delegate?.getNumberOfLevels(fromDefault: isShowingDefaultLevels) ?? 0
    }

    /// Feed in the level data itself.
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let reusableCell = collectionView
            .dequeueReusableCell(withReuseIdentifier: GameLevelListViewController.cellIdentifier,
                                 for: indexPath)

        guard let levelCell = reusableCell as? GameLevelViewCell else {
            fatalError("View Cell that extends from GameLevelViewCell is required.")
        }

        guard let dataDelegate = delegate else {
            assertionFailure("Data Delegate is missing.")
            return levelCell
        }

        let levelData = dataDelegate
            .getLevel(fromDefault: isShowingDefaultLevels, at: indexPath.item)
        let isMarked = dataDelegate
            .shouldMarkAsSelected(fromDefault: isShowingDefaultLevels, at: indexPath.item)

        levelCell.set(title: levelData.levelName)
        levelCell.set(gameType: levelData.gameType)
        levelCell.set(gameMode: levelData.gameMode)
        levelCell.isMarked = isMarked
        return levelCell
    }
}

// MARK: - Cell Size
extension GameLevelListViewController: UICollectionViewDelegateFlowLayout {

    /// Sets the size of level cell so that it fits a single row.
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }
}
