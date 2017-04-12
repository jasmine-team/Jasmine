import GameKit

/// Provides Game Center functionalities
extension UIViewController {

    private static let signInInstructionTitle = "Sign in instruction"
    private static let signInInstructionMessage = "To sign in, go to Settings > Game Center"

    private static let signOutInstructionTitle = "Sign out instruction"
    private static let signOutInstructionMessage = "Go to Settings > Game Center > Tap Apple ID > Sign Out"

    /// Shows Game Center log in instruction (from device) if user canceled log in previously
    ///
    /// - Returns: true if log in instruction is shown
    func showGKSignInInstruction() -> Bool {
        guard GKLocalPlayer.localPlayer().authenticateHandler != nil else {
            return false
        }
        showAlert(title: UIViewController.signInInstructionTitle,
                  message: UIViewController.signInInstructionMessage)
        return true
    }

    /// Shows Game Center log out instruction (from device) if user is currently logged in
    ///
    /// - Returns: true if log out instruction is shown
    func showGKSignOutInstruction() -> Bool {
        guard GKLocalPlayer.localPlayer().isAuthenticated else {
            return false
        }
        showAlert(title: UIViewController.signOutInstructionTitle,
                  message: UIViewController.signOutInstructionMessage)
        return true
    }

    /// Sets the Game Center authenticateHandler, calls `onAuthenticated` when user has authenticated successfully
    ///
    /// - Parameter onAuthenticated: will be called on successful authentication
    func setGKAuthHandler(onAuthenticated: (() -> Void)? = nil) {
        let localPlayer = GKLocalPlayer.localPlayer()
        guard onAuthenticated == nil || localPlayer.authenticateHandler == nil else {
            assertionFailure("Unable to perform onAuthenticated action as auth has already been performed earlier")
            return
        }
        localPlayer.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                self.present(viewController, animated: true)
            } else {
                guard let onAuthenticated = onAuthenticated else {
                    return
                }
                if localPlayer.isAuthenticated {
                    onAuthenticated()
                }
                self.setGKAuthHandler()
            }
        }
    }
}
