import UIKit

class HomeScreenViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameDataFactory = try? GameDataFactory() else {
            fatalError("Error with Realm")
        }
        let gameData = gameDataFactory.createGame(difficulty: 0, type: .chengYu)

        if let gridGame = segue.destination as? GridGameViewController {
            gridGame.segueWith(ChengYuGridViewModel(time: Constants.Game.Grid.time, gameData: gameData,
                                                    numberOfPhrases: Constants.Game.Grid.rows))
        } else if let tetrisGame = segue.destination as? TetrisGameViewController {
            tetrisGame.segueWith(TetrisGameViewModel(gameData: gameData))
        }
    }
}
