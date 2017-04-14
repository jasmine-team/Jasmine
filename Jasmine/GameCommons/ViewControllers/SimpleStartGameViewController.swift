import UIKit

class SimpleStartGameViewController: UIViewController {

    // MARK: Layout
    @IBOutlet private weak var gameInstructionLabel: UILabel!

    private var gameDescriptor: GameDescriptorProtocol!

    // MARK: Delegates
    /// Implement this method to receive notice that the start screen has been tapped.
    var notifyStartScreenDismissed: (() -> Void)?

    // MARK: Segue Methods
    /// Segue into this with the relevant information
    ///
    /// - Parameters:
    ///   - gameDescriptor: a descriptor that describes the game
    ///   - callback: a callback when this view is dismissed.
    func segueWith(_ gameDescriptor: GameDescriptorProtocol,
                   onScreenDismissed callback: @escaping () -> Void) {
        self.gameDescriptor = gameDescriptor
        self.notifyStartScreenDismissed = callback
    }

    // MARK: View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        gameInstructionLabel.text = gameDescriptor.gameInstruction
    }

    // MARK: Listeners and Gestures
    /// Handles the gesture as when the screen is tapped.
    @IBAction private func onStartScreenTapped(_ sender: UITapGestureRecognizer) {
        dismissView()
        notifyStartScreenDismissed?()
    }

    // MARK: Helper Methods
    private func dismissView() {
        self.view.superview?.isHidden = true
        self.view.isHidden = true
        self.view.superview?.isUserInteractionEnabled = false
        self.view.isUserInteractionEnabled = false
    }
}
