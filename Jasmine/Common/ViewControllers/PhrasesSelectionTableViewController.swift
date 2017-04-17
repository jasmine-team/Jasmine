import UIKit

class PhrasesSelectionTableViewController: PhrasesTableViewController {

    /// Indicates from which portion of the screen should the scroll divider be at
    static let scrollDividerBeforeRatio: CGFloat = 0.7
    /// Indicates whether the pan gesture is currently selecting (as opposed to de-selecting) phrases.
    /// Will be set to the opposite of whether the first phrase touched is selected.
    /// This provides a more user-friendly and intuitive multi-selection gesture.
    fileprivate var isSelecting: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLongPressGesture()
        setUpPanGesture()
    }

    private func setUpLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self,
                                                            action: #selector(openPhraseInfo(sender:)))
        view.addGestureRecognizer(longPressGesture)
    }

    @objc
    private func openPhraseInfo(sender: UILongPressGestureRecognizer) {
        guard let indexPath = tableView.indexPathForRow(at: sender.location(in: tableView)) else {
            return
        }
        showPhraseView(phraseAt: indexPath)
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

    private func setUpPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panHandler))
        panGesture.delegate = self
        tableView.addGestureRecognizer(panGesture)
    }

    /// Pan gesture handler for multi-select. 
    /// Will proceed with multi-selection only if it is not in the scrolling region, 
    /// otherwise will return and scrolling will be executed.
    @objc
    private func panHandler(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: tableView)
        guard !isInScrollingRegion(location),
              let indexPath = tableView.indexPathForRow(at: location) else {
            return
        }
        guard let isSelecting = isSelecting else {
            assertionFailure("isSelecting is not set!")
            return
        }
        if viewModel.toggle(at: indexPath.row, setToSelected: isSelecting) {
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    /// Returns if the location is within the scrolling region.
    ///
    /// - Parameter location: location of the gesture touch
    /// - Returns: true if the ratio of the touch to the tableView is less than `scrollDividerBeforeRatio`
    fileprivate func isInScrollingRegion(_ location: CGPoint) -> Bool {
        return (location.x / tableView.bounds.maxX) < PhrasesSelectionTableViewController.scrollDividerBeforeRatio
    }
}

extension PhrasesSelectionTableViewController: UIGestureRecognizerDelegate {
    /// Activates scrolling only if location is in scrolling region
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: tableView)
        return isInScrollingRegion(location)
    }

    /// Sets `isSelecting` based on whether the phrase first touched is selected
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: tableView)
        guard let row = tableView.indexPathForRow(at: location)?.row else {
            return true
        }
        isSelecting = !viewModel.get(at: row).selected
        return true
    }
}
