import UIKit
import SnapKit

class PhrasesExplorerViewController: UIViewController {

    @IBOutlet private var explorerNavigationItem: UINavigationItem!
    @IBOutlet private var phrasesTableView: UIView!
    fileprivate var phrasesTable: PhrasesTableViewController!
    fileprivate var viewModel: PhrasesExplorerViewModel!
    private var searchController: UISearchController!

    /// Callback to execute when the save button is pressed. 
    /// Passes the selected phrases to the callback function
    private var onSaveCallBack: ((Set<Phrase>) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        hideSaveButtonIfSaveNotSet()
        setupPhrasesTable()
        searchController = UISearchController(searchResultsController: phrasesTable)
        showPhrasesTable()
    }

    /// Hides the save button on the navigation panel if not markable
    private func hideSaveButtonIfSaveNotSet() {
        if onSaveCallBack == nil {
            explorerNavigationItem.rightBarButtonItem = nil
        }
    }

    private func setupPhrasesTable() {
        phrasesTable = (onSaveCallBack == nil) ? PhrasesDetailTableViewController() :
                                                 PhrasesSelectionTableViewController()
        phrasesTable.viewModel = viewModel
    }

    private func showPhrasesTable() {
        addChildViewController(phrasesTable)
        phrasesTableView.addSubview(phrasesTable.view)
        phrasesTable.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        phrasesTable.didMove(toParentViewController: self)
    }

    /// Dismisses this current screen without saving when "Back" button is pressed.
    /// Asks for conformation if selected phrases has been modified
    @IBAction private func onBackButtonPressed(_ sender: UIBarButtonItem) {
        if viewModel.hasChangedSelectedPhrases {
            showExitWithoutSavingAlert()
        } else {
            self.dismiss(animated: true)
        }

    }

    /// Dismisses this current screen and executes the callback when "Save" button is pressed.
    @IBAction private func onSaveButtonPressed(_ sender: UIBarButtonItem) {
        onSaveCallBack?(viewModel.selectedPhrases)
        self.dismiss(animated: true)
    }

    /// Injects the required data before opening this view.
    ///
    /// - Parameters:
    ///   - viewModel: the view model of this class.
    ///   - onSaveCallBack: Callback to execute when the save button is pressed. 
    ///                     Passes the selected phrases to the callback function.
    ///                     Phrases are selectable only if this is set.
    func segueWith(_ viewModel: PhrasesExplorerViewModel, onSaveCallBack: ((Set<Phrase>) -> Void)? = nil) {
        self.viewModel = viewModel
        self.onSaveCallBack = onSaveCallBack
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
