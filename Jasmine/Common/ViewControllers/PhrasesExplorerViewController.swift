import UIKit

class PhrasesExplorerViewController: UIViewController {

    fileprivate var phrasesTable: PhrasesTableViewController!
    fileprivate(set) var viewModel: PhrasesExplorerViewModel!
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
    /// When search bar starts editing: show cancel button.
    ///
    /// - Parameter searchBar: the search bar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    /// When the search bar text is changed: search for the text.
    ///
    /// - Parameters:
    ///   - searchBar: the search bar
    ///   - searchText: the text to be searched
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(keyword: searchText)
        phrasesTable.tableView.reloadData()
    }

    /// When the cancel button is clicked: resign first responder and reset search.
    ///
    /// - Parameter searchBar: the search bar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        viewModel.reset()
        searchBar.setShowsCancelButton(false, animated: true)
        phrasesTable.tableView.reloadData()
    }
}
