import UIKit

class HomeViewController: UIViewController {

    private static let levelsIndex = 1

    /// Switches to the play tab on press.
    @IBAction func onPlayPressed(_ sender: UIButton) {
        guard let tabController = self.parent as? UITabBarController else {
            return
        }
        tabController.selectedIndex = HomeViewController.levelsIndex
    }
}
