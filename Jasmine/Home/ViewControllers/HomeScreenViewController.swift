import UIKit

class HomeScreenViewController: UIViewController {
    @IBOutlet private weak var swappingChengYuButton: UIButton!
    @IBOutlet private weak var swappingCiHuiButton: UIButton!
    @IBOutlet private weak var slidingChengYuButton: UIButton!
    @IBOutlet private weak var slidingCiHuiButton: UIButton!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameManager = try? GameManager() else {
            fatalError("Error with Realm")
        }

        let level = Level()
        if let swappingGame = segue.destination as? SwappingGameViewController {
            if (sender as? UIButton) === swappingChengYuButton {
                level.gameType = .chengYu
                let gameData = gameManager.createGame(fromLevel: level)
                swappingGame.segueWith(ChengYuSwappingViewModel(time: GameConstants.Swapping.time,
                                                                gameData: gameData,
                                                                numberOfPhrases: GameConstants.Swapping.rows))
            } else if (sender as? UIButton) === swappingCiHuiButton {
                level.gameType = .ciHui
                let gameData = gameManager.createGame(fromLevel: level)
                swappingGame.segueWith(CiHuiSwappingViewModel(time: GameConstants.Swapping.time,
                                                              gameData: gameData,
                                                              numberOfPhrases: GameConstants.Swapping.rows))
            }
        } else if let tetrisGame = segue.destination as? TetrisGameViewController {
            level.gameType = .chengYu
            let gameData = gameManager.createGame(fromLevel: level)
            tetrisGame.segueWith(TetrisGameViewModel(gameData: gameData))
        } else if let slidingGame = segue.destination as? SlidingGameViewController {
            if (sender as? UIButton) === slidingChengYuButton {
                level.gameType = .chengYu
                let gameData = gameManager.createGame(fromLevel: level)
                slidingGame.segueWith(ChengYuSlidingViewModel(time: GameConstants.Sliding.time,
                                                              gameData: gameData,
                                                              rows: GameConstants.Sliding.rows))
            } else if (sender as? UIButton) === slidingCiHuiButton {
                level.gameType = .ciHui
                let gameData = gameManager.createGame(fromLevel: level)
                slidingGame.segueWith(CiHuiSlidingViewModel(time: GameConstants.Sliding.time,
                                                            gameData: gameData,
                                                            rows: GameConstants.Sliding.rows))
            }
        }
    }
}
