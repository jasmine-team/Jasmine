import UIKit
import SnapKit

class PhrasesExplorerViewController: UIViewController {

    @IBOutlet private weak var phrasesTableView: UIView!
    fileprivate var phrasesTable: PhrasesTableViewController!
    fileprivate(set) var viewModel: PhrasesExplorerViewModel!
    private var searchController: UISearchController!
    private var isMarkable: Bool!

    /// Callback to execute when the explorer view is dismissed, 
    /// passes the selected phrases to the callback function
    private var onDismiss: ((Set<Phrase>) -> ())?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPhrasesTable()
        searchController = UISearchController(searchResultsController: phrasesTable)
        showPhrasesTable()
    }

    private func setupPhrasesTable() {
        if isMarkable == true {
            phrasesTable = PhrasesSelectionTableViewController()
        } else {
            phrasesTable = PhrasesDetailTableViewController()
        }
        phrasesTable.viewModel = viewModel
    }

    private func showPhrasesTable() {
        addChildViewController(phrasesTable)
        phrasesTableView.addSubview(phrasesTable.view)
        phrasesTable.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        phrasesTable.didMove(toParentViewController: self)
    }

    /// Dismisses this current screen and executes the callback when "Back" button is pressed.
    @IBAction func onBackPressed(_ sender: UIBarButtonItem) {
        onDismiss?(viewModel.selectedPhrases)
        self.dismiss(animated: true, completion: nil)
    }

    /// Displays the level selection screen upon import pressed.
    @IBAction func onImportPressed(_ sender: UIBarButtonItem) {
        // TODO: Complete this when level import is done.
    }

    /// Injects the required data before opening this view.
    ///
    /// - Parameter viewModel: the view model of this class.
    /// - Parameter isMarkable: tells the VC whether the view can be marked (given checkmark) or not.
    /// - Parameter onDismiss: callback to execute when this view is dismissed, 
    ///                        passes the selected phrases to the callback function
    func segueWith(_ viewModel: PhrasesExplorerViewModel, isMarkable: Bool,
                   onDismiss: ((Set<Phrase>) -> ())? = nil) {
        self.viewModel = viewModel
        self.isMarkable = isMarkable
        self.onDismiss = onDismiss
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
