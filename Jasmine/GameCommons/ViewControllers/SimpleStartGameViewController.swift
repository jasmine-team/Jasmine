import UIKit

class SimpleStartGameViewController: UIViewController {

    @IBOutlet fileprivate weak var gameInstructionLabel: UILabel!

    @IBOutlet fileprivate weak var gameStartActionLabel: UILabel!

    private var gameDescriptor: GameDescriptorProtocol!

    private var startGameActionText: String!

    func segueWith(_ gameDescriptor: GameDescriptorProtocol, startGameText actionText: String) {
        self.gameDescriptor = gameDescriptor
        self.startGameActionText = actionText
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gameInstructionLabel.text = gameDescriptor.gameInstruction
        gameStartActionLabel.text = startGameActionText
    }
}
