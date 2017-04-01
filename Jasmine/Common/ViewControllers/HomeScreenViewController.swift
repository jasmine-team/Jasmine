import UIKit

class HomeScreenViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gridGame = segue.destination as? GridGameViewController {
            gridGame.segueWith(GridViewModel())

        } else if let tetrisGame = segue.destination as? TetrisGameViewController {
            tetrisGame.segueWith(TetrisGameViewModel())
        }
    }
}
