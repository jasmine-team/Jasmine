import UIKit

extension UIViewController {

    /// Returns an alert controller with cancel button
    ///
    /// - Parameters:
    ///   - title: title of the alert
    ///   - message: message for the alert
    /// - Returns: UIAlertController with cancel button
    func getAlertControllerWithCancel(title: String, message: String? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
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
        showAlert(title: "Error", message: error.localizedDescription)
    }
}
