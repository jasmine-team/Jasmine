import UIKit

class PhrasesExplorerViewController: UIViewController {

    private var phrasesTable: PhrasesTableViewController!
    private var viewModel: PhrasesExplorerViewModel!
    private var searchController: UISearchController!

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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let table = segue.destination as? PhrasesTableViewController {
            phrasesTable = table
            phrasesTable.viewModel = viewModel
            searchController = UISearchController(searchResultsController: phrasesTable)
        }
    }
}
