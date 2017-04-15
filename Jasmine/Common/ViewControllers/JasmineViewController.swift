import UIKit

/// The base view controller class that contains a navigation bar.
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
    func setLayout(navigationBar: UINavigationBar, withTitle title: String?) {
        self.navigationBar = navigationBar
        self.navigationBar.topItem?.title = title
        setThemeForNavigationBar()
        setDismissButtonForNavigationBar()
    }

    @objc
    func dismissViewController() {
        self.dismiss(animated: true)
    }

    // MARK: Helper Methods
    func setThemeForNavigationBar() {
        self.navigationBar.backgroundColor = Constants.Theme.mainColorDark
        self.navigationBar.isTranslucent = false
    }

    private func setDismissButtonForNavigationBar() {
        self.navigationBar.items?.forEach {
            guard let barItem = $0.leftBarButtonItem,
                barItem.title == JasmineViewController.backLabel else {
                    return
            }
            barItem.action = #selector(dismissViewController)
        }
    }

}
