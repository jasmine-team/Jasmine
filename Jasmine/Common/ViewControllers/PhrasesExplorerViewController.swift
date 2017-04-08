import UIKit

class PhrasesExplorerViewController: UIViewController {

    @IBOutlet private weak var phrasesTable: UITableView!
    fileprivate var viewModel: PhrasesExplorerViewModel!
    private var tableDelegate: PhrasesTableViewDelegate!

    override func viewDidLoad() {
        tableDelegate = PhrasesTableViewDelegate()
        tableDelegate.viewModel = viewModel
        tableDelegate.tableView = phrasesTable

        phrasesTable.delegate = tableDelegate
    }

    /// Dismisses this current screen when "Back" button is pressed.
    @IBAction func onBackPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    /// Injects the required data before opening this view.
    ///
    /// - Parameter viewModel: the view model of this class.
    func segueWith(_ viewModel: PhrasesExplorerViewModel) {
        self.viewModel = viewModel
    }
}

extension PhrasesExplorerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.amount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhraseExplorerCell", for: indexPath)

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
}
