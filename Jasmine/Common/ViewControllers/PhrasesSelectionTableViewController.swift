import UIKit

class PhrasesSelectionTableViewController: PhrasesTableViewController {
    /// Executed when rows of the table is selected
    ///
    /// - Parameters:
    ///   - tableView: the table view
    ///   - indexPath: the index path selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggle(at: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
