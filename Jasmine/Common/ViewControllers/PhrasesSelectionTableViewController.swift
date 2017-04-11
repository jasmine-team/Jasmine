import UIKit

class PhrasesSelectionTableViewController: PhrasesTableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(openPhraseInfo(sender:)))
        view.addGestureRecognizer(longPressGesture)
    }
    /// Executed when rows of the table is selected
    ///
    /// - Parameters:
    ///   - tableView: the table view
    ///   - indexPath: the index path selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggle(at: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .none)
    }

    @objc
    private func openPhraseInfo(sender: UILongPressGestureRecognizer) {
        guard let indexPath = tableView.indexPathForRow(at: sender.location(in: tableView)) else {
            return
        }
        showPhraseView(phraseAt: indexPath)
    }
}
