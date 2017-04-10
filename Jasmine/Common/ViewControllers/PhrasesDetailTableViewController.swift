import UIKit

class PhrasesDetailTableViewController: PhrasesTableViewController {
    /// Executed when rows of the table is selected
    ///
    /// - Parameters:
    ///   - tableView: the table view
    ///   - indexPath: the index path selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "CommonsStoryboard", bundle: nil)
        guard let phraseVC = storyboard.instantiateViewController(
            withIdentifier: "PhraseViewController") as? PhraseViewController else {
                assertionFailure("Can't segue to PhraseView")
                return
        }

        phraseVC.segueWith(viewModel.getPhraseViewModel(at: indexPath.row))

        present(phraseVC, animated: true, completion: nil)
    }
}
