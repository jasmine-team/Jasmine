import UIKit

class AboutViewController: UIViewController {
    /// Dismisses this current screen when "Back" button is pressed.
    @IBAction func onBackPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
}
