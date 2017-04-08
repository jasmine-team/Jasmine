import UIKit

class PhrasesTableViewController: UITableViewController {
    var viewModel: PhrasesExplorerViewModel!

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.amount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhrasesTableCell", for: indexPath)

        let row = indexPath.row
        let cellContents = viewModel.get(at: row)
        cell.textLabel?.text = cellContents.chinese
        if cellContents.selected {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggle(at: indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
