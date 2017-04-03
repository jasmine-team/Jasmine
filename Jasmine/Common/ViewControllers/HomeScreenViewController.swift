import UIKit

class HomeScreenViewController: UIViewController {
    @IBOutlet private weak var gridChengYuButton: UIButton!

    @IBOutlet private weak var gridCiHuiButton: UIButton!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameDataFactory = try? GameDataFactory() else {
            fatalError("Error with Realm")
        }

        if let gridGame = segue.destination as? GridGameViewController {
            if (sender as? UIButton) === gridChengYuButton {
                let gameData = gameDataFactory.createGame(difficulty: 0, type: .chengYu)
                gridGame.segueWith(ChengYuGridViewModel(time: Constants.Game.Grid.time, gameData: gameData,
                                                        numberOfPhrases: Constants.Game.Grid.rows))
            } else if (sender as? UIButton) === gridCiHuiButton {
                let gameData = gameDataFactory.createGame(difficulty: 0, type: .ciHui)
                gridGame.segueWith(CiHuiGridViewModel(time: Constants.Game.Grid.time, gameData: gameData,
                                                      numberOfPhrases: Constants.Game.Grid.rows))
            }
        } else if let tetrisGame = segue.destination as? TetrisGameViewController {
            let gameData = gameDataFactory.createGame(difficulty: 0, type: .chengYu)
            tetrisGame.segueWith(TetrisGameViewModel(gameData: gameData))

        } else if let slidingGame = segue.destination as? SlidingGameViewController {
            slidingGame.segueWith(MockSlidingViewModel())
        }
    }
}
