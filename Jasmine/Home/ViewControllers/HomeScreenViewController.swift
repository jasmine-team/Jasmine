import UIKit
import RealmSwift

class HomeScreenViewController: UIViewController {
    @IBOutlet private weak var swappingChengYuButton: UIButton!
    @IBOutlet private weak var swappingCiHuiButton: UIButton!
    @IBOutlet private weak var slidingChengYuButton: UIButton!
    @IBOutlet private weak var slidingCiHuiButton: UIButton!

    var realm: Realm!
    var levels: Levels!

    /// TODO: Move realm dependency else where
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            realm = try Realm()
            levels = Levels(realm: realm)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameManager = GameManager(realm: realm)
        // Refer to levels.csv
        let chengYuGameData = gameManager.createGame(fromLevel: levels.original[3])
        let ciHuiGameData = gameManager.createGame(fromLevel: levels.original[0])
        if let swappingGame = segue.destination as? SwappingGameViewController {
            if (sender as? UIButton) === swappingChengYuButton {

                swappingGame.segueWith(ChengYuSwappingViewModel(time: GameConstants.Swapping.time,
                                                                gameData: chengYuGameData,
                                                                numberOfPhrases: GameConstants.Swapping.rows))
            } else if (sender as? UIButton) === swappingCiHuiButton {
                swappingGame.segueWith(CiHuiSwappingViewModel(time: GameConstants.Swapping.time,
                                                              gameData: ciHuiGameData,
                                                              numberOfPhrases: GameConstants.Swapping.rows))
            }
        } else if let tetrisGame = segue.destination as? TetrisGameViewController {
            tetrisGame.segueWith(TetrisGameViewModel(gameData: chengYuGameData))
        } else if let slidingGame = segue.destination as? SlidingGameViewController {
            if (sender as? UIButton) === slidingChengYuButton {
                slidingGame.segueWith(ChengYuSlidingViewModel(time: GameConstants.Sliding.time,
                                                              gameData: chengYuGameData,
                                                              rows: GameConstants.Sliding.rows))
            } else if (sender as? UIButton) === slidingCiHuiButton {
                slidingGame.segueWith(CiHuiSlidingViewModel(time: GameConstants.Sliding.time,
                                                            gameData: ciHuiGameData,
                                                            rows: GameConstants.Sliding.rows))
            }
        } else if let phrasesExplorer = segue.destination as? PhrasesExplorerViewController {
            let viewModel = PhrasesExplorerViewModel(phrases: ciHuiGameData.phrases, amount: 50)
            phrasesExplorer.segueWith(viewModel)
        } else if let phraseVC = segue.destination as? PhraseViewController {
            let phrase = ciHuiGameData.phrases.randomGenerator.next()
            phraseVC.segueWith(PhraseViewModel(phrase: phrase))
        }
    }
}
