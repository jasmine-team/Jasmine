import UIKit
import AVFoundation

class PhraseViewController: UIViewController {

    fileprivate static let backgroundAudioWhileTts: Float = 0.1

    @IBOutlet private weak var hanZiLabel: UILabel!
    @IBOutlet private weak var pinYinLabel: UILabel!
    @IBOutlet private weak var englishLabel: UILabel!
    @IBOutlet fileprivate weak var speechButton: UIButton!

    private let synthesizer = AVSpeechSynthesizer()
    private var viewModel: PhraseViewModel!
    fileprivate var originalVolume = PhraseViewController.backgroundAudioWhileTts

    @IBAction private func playButtonPressed(_ sender: Any) {
        synthesizer.speak(viewModel.speech)
    }

    override func viewDidLoad() {
        synthesizer.delegate = self
        displayText()
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

    private func displayText() {
        hanZiLabel.text = viewModel.hanZi
        pinYinLabel.text = viewModel.pinYin
        englishLabel.text = viewModel.english
    }
}

extension PhraseViewController: AVSpeechSynthesizerDelegate {

    /// Disables the play button, and tune down the background volume when the TTS is speaking
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        speechButton.isEnabled = false

        originalVolume = SoundService.sharedInstance.backgroundVolume
        SoundService.sharedInstance.backgroundVolume
            = min(PhraseViewController.backgroundAudioWhileTts, originalVolume)
    }

    /// Resets what has been modified by the TTS.
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        speechButton.isEnabled = true
        SoundService.sharedInstance.backgroundVolume = originalVolume
    }

}
