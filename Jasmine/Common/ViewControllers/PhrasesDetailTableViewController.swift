import UIKit

class PhrasesDetailTableViewController: PhrasesTableViewController {
    /// Executed when rows of the table is selected
    ///
    /// - Parameters:
    ///   - tableView: the table view
    ///   - indexPath: the index path selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showPhraseView(phraseAt: indexPath)
    }
}
