import UIKit

class PhrasesTableViewController: UITableViewController {
    /// The ViewModel of this ViewController
    var viewModel: PhrasesExplorerViewModel!

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.rowsShown
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhrasesTableCell", for: indexPath)

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
