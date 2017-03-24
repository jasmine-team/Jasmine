import UIKit

class HomeScreenViewController: UIViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let gridGame = segue.destination as? GridGameViewController {
            guard let gameData = try? GameDataFactory() else {
                fatalError("Error with Realm")
            }
            let phrases = gameData.createGame(difficulty: 0).phrases
            gridGame.segueWith(GridViewModel(time: Constants.Grid.time, answers: phrases))
        }
    }
}
