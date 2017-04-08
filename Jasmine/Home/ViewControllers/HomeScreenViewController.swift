import UIKit

class HomeScreenViewController: UIViewController {
    @IBOutlet private weak var swappingChengYuButton: UIButton!
    @IBOutlet private weak var swappingCiHuiButton: UIButton!
    @IBOutlet private weak var slidingChengYuButton: UIButton!
    @IBOutlet private weak var slidingCiHuiButton: UIButton!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let gameDataFactory = try? GameDataFactory() else {
            fatalError("Error with Realm")
        }

        if let swappingGame = segue.destination as? SwappingGameViewController {
            if (sender as? UIButton) === swappingChengYuButton {
                let gameData = gameDataFactory.createGame(difficulty: 0, type: .chengYu)
                swappingGame.segueWith(ChengYuSwappingViewModel(time: GameConstants.Swapping.time,
                                                                gameData: gameData,
                                                                numberOfPhrases: GameConstants.Swapping.rows))
            } else if (sender as? UIButton) === swappingCiHuiButton {
                let gameData = gameDataFactory.createGame(difficulty: 0, type: .ciHui)
                swappingGame.segueWith(CiHuiSwappingViewModel(time: GameConstants.Swapping.time,
                                                              gameData: gameData,
                                                              numberOfPhrases: GameConstants.Swapping.rows))
            }
        } else if let tetrisGame = segue.destination as? TetrisGameViewController {
            let gameData = gameDataFactory.createGame(difficulty: 0, type: .chengYu)
            tetrisGame.segueWith(TetrisGameViewModel(gameData: gameData))
        } else if let slidingGame = segue.destination as? SlidingGameViewController {
            if (sender as? UIButton) === slidingChengYuButton {
                let gameData = gameDataFactory.createGame(difficulty: 0, type: .chengYu)
                slidingGame.segueWith(ChengYuSlidingViewModel(time: GameConstants.Sliding.time,
                                                              gameData: gameData,
                                                              rows: GameConstants.Sliding.rows))
            } else if (sender as? UIButton) === slidingCiHuiButton {
                let gameData = gameDataFactory.createGame(difficulty: 0, type: .ciHui)
                slidingGame.segueWith(CiHuiSlidingViewModel(time: GameConstants.Sliding.time,
                                                            gameData: gameData,
                                                            rows: GameConstants.Sliding.rows))
            }
        } else if let phrasesExplorer = segue.destination as? PhrasesExplorerViewController {
            let gameData = gameDataFactory.createGame(difficulty: 0, type: .ciHui)
            let viewModel = PhrasesExplorerViewModel(phrases: gameData.phrases, amount: 50)
            phrasesExplorer.segueWith(viewModel)
        } else if let phraseVC = segue.destination as? PhraseViewController {
            let gameData = gameDataFactory.createGame(difficulty: 0, type: .chengYu)
            let phrase = gameData.phrases.next()
            phraseVC.segueWith(PhraseViewModel(phrase: phrase))
        }
    }
}
