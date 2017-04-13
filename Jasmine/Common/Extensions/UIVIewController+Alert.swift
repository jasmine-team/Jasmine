import UIKit

extension UIViewController {

    private static let cancelActionText = "Cancel"
    private static let errorControllerTitle = "Error"

    private static let exitWithoutSavingAlertTitle = "Exit without saving?"
    private static let conformExitWithoutSavingActionText = "Yes"

    /// Returns an alert controller with cancel button
    ///
    /// - Parameters:
    ///   - title: Title of the alert
    ///   - message: Message for the alert
    /// - Returns: UIAlertController with cancel button
    private func getAlertControllerWithCancel(title: String, message: String? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: UIViewController.cancelActionText, style: .cancel))
        return alertController
    }

    /// Displays an alert pop up with a cancel button
    ///
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: message for the alert
    func showAlert(title: String, message: String) {
        present(getAlertControllerWithCancel(title: title, message: message), animated: true)
    }

    /// Display an alert pop up with a cancel button and another button with `actionText` 
    /// and executes `onActionButtonPressed` on pressed
    ///
    /// - Parameters:
    ///   - title: Title of the alert
    ///   - actionText: Message for the alert
    ///   - onActionButtonPressed: Callback to execute when button is pressed
    func showAlert(title: String, actionText: String, onActionButtonPressed: @escaping () -> Void) {
        let alert = getAlertControllerWithCancel(title: title)
        let action = UIAlertAction(title: actionText, style: .destructive) { _ in
            onActionButtonPressed()
        }
        alert.addAction(action)
        present(alert, animated: true)

    }

    /// Displays an error pop up with a cancel button
    ///
    /// - Parameters:
    ///   - error: the error to show
    func showError(_ error: Error) {
        showAlert(title: UIViewController.errorControllerTitle, message: error.localizedDescription)
    }

    /// Displays an exit without saving alert, which dismisses the view if conformed to exit.
    /// Returns to the current view if cancel is selected
    func showExitWithoutSavingAlert() {
        showAlert(title: UIViewController.exitWithoutSavingAlertTitle,
                  actionText: UIViewController.conformExitWithoutSavingActionText) {
            self.dismiss(animated: true)
        }
    }
}
