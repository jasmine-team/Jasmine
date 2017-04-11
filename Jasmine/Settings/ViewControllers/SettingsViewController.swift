import GameKit

class SettingsViewController: UIViewController {

    @IBOutlet private var signInButton: UIButton!

    private static let signInLabel = "SIGN IN"
    private static let signOutLabel = "SIGN OUT"

    private static let signInDisabledTitle = "Sign in instruction"
    private static let signInDisabledMessage = "To sign in, go to Settings > Game Center"

    private static let signOutInstructionTitle = "Sign out instruction"
    private static let signOutInstructionMessage = "Go to Settings > Game Center > Tap Apple ID > Sign Out"

    override func viewDidLoad() {
        super.viewDidLoad()
        setSignInButtonText()
    }

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

    @IBAction private func onBackPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    /// If user is signed in, display instruction to sign out.
    /// If user cancelled sign in previously, display instruction to sign in.
    /// Otherwise prompt the user to sign in
    @IBAction private func onSignInButtonPressed(_ slider: UIButton) {
        if GKLocalPlayer.localPlayer().isAuthenticated {
            showAlert(title: SettingsViewController.signOutInstructionTitle,
                      message: SettingsViewController.signOutInstructionMessage)
        } else if !promptSignIn() {
            showAlert(title: SettingsViewController.signInDisabledTitle,
                      message: SettingsViewController.signInDisabledMessage)
        }
    }

    /// Prompt the user to sign in if the user has not been prompted to sign in previously
    ///
    /// - Returns: true if user gets prompted to sign in (i.e. this is the first time getting prompted)
    private func promptSignIn() -> Bool {
        let localPlayer = GKLocalPlayer.localPlayer()
        guard localPlayer.authenticateHandler == nil else {
            return false
        }

        localPlayer.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                self.present(viewController, animated: true)
            } else {
                self.setSignInButtonText()
            }
        }
        return true
    }

    // MARK: Theme
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
