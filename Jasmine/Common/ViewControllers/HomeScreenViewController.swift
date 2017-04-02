import UIKit

class HomeScreenViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gridGame = segue.destination as? GridGameViewController {
            guard let gameDataFactory = try? GameDataFactory() else {
                fatalError("Error with Realm")
            }
            let gameData = gameDataFactory.createGame(difficulty: 0, type: .ciHui)
            gridGame.segueWith(CiHuiGridViewModel(time: Constants.Game.Grid.time,
                                                  gameData: gameData,
                                                  numberOfPhrases: Constants.Game.Grid.rows))

        } else if let tetrisGame = segue.destination as? TetrisGameViewController {
            tetrisGame.segueWith(TetrisGameViewModel())
        }
    }
}
