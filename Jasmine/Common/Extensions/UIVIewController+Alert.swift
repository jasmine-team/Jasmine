import UIKit

extension UIViewController {

    private static let cancelActionText = "Cancel"
    private static let errorControllerTitle = "Error"

    /// Returns an alert controller with cancel button
    ///
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: message for the alert
    /// - Returns: UIAlertController with cancel button
    func getAlertControllerWithCancel(title: String, message: String? = nil) -> UIAlertController {
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

    /// Displays an error pop up with a cancel button
    ///
    /// - Parameters:
    ///   - error: the error to show
    func showError(_ error: Error) {
        showAlert(title: UIViewController.errorControllerTitle, message: error.localizedDescription)
    }
}
