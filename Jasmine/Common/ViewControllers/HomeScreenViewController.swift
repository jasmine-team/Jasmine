import UIKit

class HomeScreenViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gridGame = segue.destination as? GridGameViewController {
            gridGame.segueWith(BaseGridViewModel(time: Constants.Game.Grid.time,
                                                 answers: [["1", "2", "3"], ["4", "5", "6"], ["7", "8", "9"]]))
        }
    }
}
