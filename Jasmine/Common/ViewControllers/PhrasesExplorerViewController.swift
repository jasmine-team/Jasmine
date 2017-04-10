import UIKit

class PhrasesExplorerViewController: UIViewController {

    fileprivate var phrasesTable: PhrasesTableViewController!
    fileprivate var viewModel: PhrasesExplorerViewModel!
    private var searchController: UISearchController!

    /// Dismisses this current screen when "Back" button is pressed.
    @IBAction func onBackPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    /// Displays the level selection screen upon import pressed.
    @IBAction func onImportPressed(_ sender: UIBarButtonItem) {
        // TODO: Complete this when level import is done.
    }

    /// Injects the required data before opening this view.
    ///
    /// - Parameter viewModel: the view model of this class.
    func segueWith(_ viewModel: PhrasesExplorerViewModel) {
        self.viewModel = viewModel
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let table = segue.destination as? PhrasesTableViewController {
            phrasesTable = table
            phrasesTable.viewModel = viewModel
            searchController = UISearchController(searchResultsController: phrasesTable)
        }
    }
}

extension PhrasesExplorerViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(true, animated: true)

        guard let text = searchBar.text else {
            return
        }

        viewModel.search(keyword: text)
        phrasesTable.tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.reset()
        searchBar.setShowsCancelButton(false, animated: true)
        phrasesTable.tableView.reloadData()
    }
}
