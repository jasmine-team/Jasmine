import UIKit

class GameLevelListViewController: UIViewController {

    // MARK: Constants
    fileprivate static let cellIdentifier = "GameLevelViewCell"

    private static let builtInLevelsIndex = 0
    private static let customLevelsIndex = 1

    // MARK: Layout
    @IBOutlet private weak var levelsCategoriesToggle: UISegmentedControl!

    @IBOutlet private weak var gameLevelListCollection: UICollectionView!

    // MARK: Properties
    /// Specifies a delegate to read the data from.
    weak var dataDelegate: GameLevelListDataDelegate?

    /// Returna true if default levels should be shown.
    fileprivate var isShowingDefaultLevels: Bool {
        return levelsCategoriesToggle.selectedSegmentIndex
            == GameLevelListViewController.builtInLevelsIndex
    }

    /// Gets all the indices displayed in this view.
    private var allIndices: Set<IndexPath> {
        let numItems = dataDelegate?.getNumberOfLevels(fromDefault: isShowingDefaultLevels) ?? 0
        return Set((0..<numItems).map { IndexPath(row: $0, section: 0) })
    }

    // MARK: Segue Methods
    /// Supply this view with a data delegate.
    func segueWith(dataDelegate: GameLevelListDataDelegate) {
        self.dataDelegate = dataDelegate
    }
    
    // MARK: Gestures and Listeners
    /// Updates the level categories based on what has been toggled in the view.
    @IBAction private func onLevelsCategoriesSwitched() {
        reloadAllData()
    }

    /// Notifies that a level has been selected.
    @IBAction private func onLevelSelected(_ sender: UITapGestureRecognizer) {
        let tappedLocation = sender.location(in: gameLevelListCollection)
        guard let indexPath = gameLevelListCollection.indexPathForItem(at: tappedLocation),
              let cell = gameLevelListCollection.cellForItem(at: indexPath) as? GameLevelViewCell else {
            return
        }
        dataDelegate?.notifyLevelSelected(fromDefault: isShowingDefaultLevels, at: indexPath.item,
                                          withCell: cell)
    }

    // MARK: Interfacing Methods
    /// Reloads all the data in this view.
    func reloadAllData() {
        gameLevelListCollection.reloadItems(at: Array(allIndices))
    }
}

// MARK: - Data Source
extension GameLevelListViewController: UICollectionViewDataSource {

    /// Feed in the number of levels to display.
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {

        return dataDelegate?.getNumberOfLevels(fromDefault: isShowingDefaultLevels) ?? 0
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

        guard let dataDelegate = dataDelegate else {
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
