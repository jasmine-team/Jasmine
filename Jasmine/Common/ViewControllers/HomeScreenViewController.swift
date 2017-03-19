import UIKit

class HomeScreenViewController: UIViewController {

    // TODO: update this when Home Screen is completed.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gridGame = segue.destination as? GridGameViewController {
            gridGame.segueWith(MockGridGameEngine())
        }
    }
}
