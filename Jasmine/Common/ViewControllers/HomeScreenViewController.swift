import UIKit

class HomeScreenViewController: UIViewController {
    @IBOutlet private weak var swappingChengYuButton: UIButton!

    @IBOutlet private weak var swappingCiHuiButton: UIButton!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameDataFactory = try? GameDataFactory() else {
            fatalError("Error with Realm")
        }

        if let swappingGame = segue.destination as? SwappingGameViewController {
            if (sender as? UIButton) === swappingChengYuButton {
                let gameData = gameDataFactory.createGame(difficulty: 0, type: .chengYu)
                swappingGame.segueWith(ChengYuSwappingViewModel(time: Constants.Game.Swapping.time,
                                                                gameData: gameData,
                                                                numberOfPhrases: Constants.Game.Swapping.rows))
            } else if (sender as? UIButton) === swappingCiHuiButton {
                let gameData = gameDataFactory.createGame(difficulty: 0, type: .ciHui)
                swappingGame.segueWith(CiHuiSwappingViewModel(time: Constants.Game.Swapping.time,
                                                              gameData: gameData,
                                                              numberOfPhrases: Constants.Game.Swapping.rows))
            }
        } else if let tetrisGame = segue.destination as? TetrisGameViewController {
            let gameData = gameDataFactory.createGame(difficulty: 0, type: .chengYu)
            tetrisGame.segueWith(TetrisGameViewModel(gameData: gameData))
        }
    }
}
