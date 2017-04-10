import UIKit

class LevelSelectionViewController: UIViewController {

    // MARK: Layouts
    private var levelCollection: GameLevelListViewController!

    // MARK: View Controller Lifecycle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let levelCollection = segue.destination as? GameLevelListViewController {
            self.levelCollection = levelCollection
            self.levelCollection.segueWith(delegate: self)
        }
    }



    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onDesignNewLevelPressed(_ sender: Any) {

    }
}

extension LevelSelectionViewController: GameLevelListViewDelegate {

    /// Gets the number of levels.
    ///
    /// - Parameter isDefaultLevels: true if number of levels from default, false from custom.
    /// - Returns: the number of levels.
    func getNumberOfLevels(fromDefault isDefaultLevels: Bool) -> Int {
        return
    }

    /// Gets a specific level data from the specific index in an ordered list.
    ///
    /// - Parameter isDefaultLevels: true if levels from default, false from custom.
    /// - Returns: the specific level data from the specified index.
    /// - Precondition: index should range from 0 to `getNumberOfLevels`.
    func getLevel(fromDefault isDefaultLevels: Bool, at index: Int) -> GameInfo {
        return
    }

    /// Asks the user of this view controller if the level should be mark as selected.
    func shouldMarkAsSelected(fromDefault isDefaultLevels: Bool, at index: Int) -> Bool {
        return false
    }

    /// Notifies the user of this view controller that a level has been selected.
    func notifyLevelSelected(fromDefault isDefaultLevels: Bool, at index: Int,
                             withCell levelCell: GameLevelViewCell) {


    }

    /// Notifies the user of this view controller to open the list of menu for the specified level.
    func notifyOpenMenuForLevel(fromDefault isDefaultLevels: Bool, at index: Int) {

    }

}
