import UIKit

class PhrasesTableViewController: UITableViewController {

    private static let cellIdentifier = "PhrasesTableCell"

    /// The ViewModel of this ViewController
    var viewModel: PhrasesExplorerViewModel!

    override func viewDidLoad() {
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: PhrasesTableViewController.cellIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowsShown
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhrasesTableViewController.cellIdentifier,
                                                 for: indexPath)

        let row = indexPath.row
        let cellContents = viewModel.get(at: row)
        cell.textLabel?.text = "\(cellContents.chinese) (\(cellContents.english))"
        if cellContents.selected {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    func showPhraseView(phraseAt indexPath: IndexPath) {
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
