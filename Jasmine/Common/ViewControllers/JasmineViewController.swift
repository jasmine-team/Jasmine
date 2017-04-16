import UIKit

/// The base view controller class that contains a navigation bar.
/// - Note: to make use of the "BACK" button, requires a "BACK" button on the left bar button item.
class JasmineViewController: UIViewController {

    // MARK: Constants
    fileprivate static let backLabel = "BACK"

    // MARK: Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: Layouts
    fileprivate var navigationBar: UINavigationBar!

    // MARK: Layout Setters
    /// Sets the navigation bar with a title, and the dismiss method.
    func setLayout(navigationBar: UINavigationBar, withTitle title: String? = nil) {
        self.navigationBar = navigationBar
        setThemeForNavigationBar()
        setDismissButtonForNavigationBar()

        if let title = title {
            self.navigationBar.topItem?.title = title
        }
    }

    /// Dismiss this view controller when the "BACK" button is pressed on the nav bar.
    @objc
    func onDismissPressed() {
        self.dismiss(animated: true)
    }

    // MARK: Helper Methods
    private func setThemeForNavigationBar() {
        self.navigationBar.backgroundColor = Constants.Theme.mainColorDark
        self.navigationBar.isTranslucent = false
    }

    private func setDismissButtonForNavigationBar() {
        self.navigationBar.items?.forEach {
            guard let barItem = $0.leftBarButtonItem,
                barItem.title == JasmineViewController.backLabel else {
                    return
            }
            barItem.action = #selector(onDismissPressed)
        }
    }
}
