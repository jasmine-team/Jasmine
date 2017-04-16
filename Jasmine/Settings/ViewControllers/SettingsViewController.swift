import GameKit

class SettingsViewController: JasmineViewController {

    @IBOutlet private var signInButton: UIButton!

    @IBOutlet private weak var navigationBar: UINavigationBar!

    private static let signInLabel = "SIGN IN"
    private static let signOutLabel = "SIGN OUT"

    override func viewDidLoad() {
        super.viewDidLoad()
        super.setLayout(navigationBar: navigationBar)
        setSignInButtonText()
    }

    /// If user is signed in, set sign in button text to signOutLabel, else set it to signInLabel 
    private func setSignInButtonText() {
        let buttonTitle = GKLocalPlayer.localPlayer().isAuthenticated ?
                          SettingsViewController.signOutLabel :
                          SettingsViewController.signInLabel
        signInButton.setTitle(buttonTitle, for: .normal)
    }

    @IBAction private func onBackgroundMusicSliderPressed(_ slider: UISlider) {
        SoundService.sharedInstance.backgroundVolume = slider.value
    }

    @IBAction private func onSoundEffectsSliderPressed(_ slider: UISlider) {
        SoundService.sharedInstance.effectVolume = slider.value
    }

    /// If user is signed in, display instruction to sign out.
    /// If user cancelled sign in previously, display instruction to sign in.
    /// Otherwise prompt the user to sign in
    @IBAction private func onSignInButtonPressed(_ slider: UIButton) {
        guard !showGKSignInInstruction() && !showGKSignOutInstruction() else {
            return
        }
        setGKAuthHandler(onAuthenticated: setSignInButtonText)
    }

    // MARK: Theme
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
