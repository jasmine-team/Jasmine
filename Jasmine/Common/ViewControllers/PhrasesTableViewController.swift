import UIKit

class PhrasesTableViewController: UITableViewController {

    private static let cellIdentifier = "PhrasesTableCell"

    /// The ViewModel of this ViewController
    var viewModel: PhrasesExplorerViewModel!

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowsShown
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PhrasesSelectionTableViewController.cellIdentifier,
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
}
