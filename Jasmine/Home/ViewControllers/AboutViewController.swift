import UIKit

class AboutViewController: JasmineViewController {

    @IBOutlet private weak var navigationBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        super.setLayout(navigationBar: navigationBar)
    }
}
