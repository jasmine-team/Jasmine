import UIKit

/// The base view controller class that contains a navigation bar.
class JasmineViewController: UIViewController {

    // MARK: Layouts
    fileprivate var navigationBar: UINavigationBar!

    // MARK: Layout Setters
    func setLayout(navigationBar: UINavigationBar, withTitle title: String?) {
        self.navigationBar = navigationBar
        self.navigationBar.topItem?.title = title
        setThemeForNavigationBar()
    }

    // MARK: Theme
    func setThemeForNavigationBar() {
        self.navigationBar.backgroundColor = Constants.Theme.mainColorDark
        self.navigationBar.isTranslucent = false
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
