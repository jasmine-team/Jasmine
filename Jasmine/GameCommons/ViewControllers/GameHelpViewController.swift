import UIKit

class GameHelpViewController: UIViewController {

    // MARK: Layout
    @IBOutlet private weak var gameTitleLabel: UILabel!

    @IBOutlet private weak var gameInstructionsLabel: UILabel!

    // MARK: Properties
    private var gameDescriptor: GameDescriptorProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setText()
    }

    func segueWith(_ gameDescriptor: GameDescriptorProtocol) {
        self.gameDescriptor = gameDescriptor
    }

    @IBAction func onBackPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    private func setBackground() {
        view.backgroundColor = nil
        view.isOpaque = false
        self.modalPresentationStyle = .overCurrentContext
    }

    private func setText() {
        gameTitleLabel.text = gameDescriptor.gameTitle
        gameInstructionsLabel.text = gameDescriptor.gameInstruction
    }
}
