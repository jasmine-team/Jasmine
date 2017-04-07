import GameKit

class SettingsViewController: UIViewController {

    @IBOutlet private var signInButton: UIButton!

    private static let signInLabel = "Sign in"
    private static let signOutLabel = "Sign out"

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

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
    }
}
