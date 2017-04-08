import UIKit
import AVFoundation

class PhraseViewController: UIViewController {

    @IBOutlet private weak var hanZiLabel: UILabel!
    @IBOutlet private weak var pinYinLabel: UILabel!
    @IBOutlet private weak var englishLabel: UILabel!

    private let synthesizer = AVSpeechSynthesizer()

    private var viewModel: PhraseViewModel!

    @IBAction private func playButtonPressed(_ sender: Any) {
        synthesizer.speak(viewModel.speech)
    }

    override func viewDidLoad() {
        hanZiLabel.text = viewModel.hanZi
        pinYinLabel.text = viewModel.pinYin
        englishLabel.text = viewModel.english
    }

    /// Injects the required data before opening this view.
    ///
    /// - Parameter viewModel: the view model of this class.
    func segueWith(_ viewModel: PhraseViewModel) {
        self.viewModel = viewModel
    }

    /// Dismisses this current screen when "Back" button is pressed.
    @IBAction func onBackPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
