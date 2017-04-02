import UIKit

class HomeScreenViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameDataFactory = try? GameDataFactory() else {
            fatalError("Error with Realm")
        }

        if let gridGame = segue.destination as? GridGameViewController {
            gridGame.segueWith(GridViewModel())

        } else if let tetrisGame = segue.destination as? TetrisGameViewController {
            let gameData = gameDataFactory.createGame(difficulty: 0, type: .chengYu)
            tetrisGame.segueWith(TetrisGameViewModel(gameData: gameData))

        } else if let slidingGame = segue.destination as? SlidingGameViewController {
            slidingGame.segueWith(MockSlidingViewModel())
        }
    }
}
