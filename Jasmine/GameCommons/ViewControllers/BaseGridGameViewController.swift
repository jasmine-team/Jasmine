import UIKit

/// Sets the base game view controller for all the view controller class.
/// - Note:
///   - The storyboard must contain what is required in `BaseGameViewController`, and
///     - A `DraggableSquareGridViewController` view.
class BaseGridGameViewController: BaseGameViewController {

    // MARK: - Constants
    fileprivate static let highlightDelay = 0.2

    // MARK: - Layouts
    fileprivate var gridView: DraggableSquareGridViewController!

    fileprivate var gridViewModel: GridViewModelProtocol!

    // MARK: - Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let gridView = segue.destination as? DraggableSquareGridViewController {
            self.gridView = gridView
            self.gridView.segueWith(gridViewModel.gridData)
        }
    }

    func segueWith(_ gridViewModel: GridViewModelProtocol) {
        super.segueWith(gridViewModel)
        self.gridViewModel = gridViewModel
        self.gridViewModel.highlightedDelegate = self
    }
}

extension BaseGridGameViewController: HighlightedUpdateDelegate {

    /// Tells the implementor of the delegate that the highlighted coordinates have been changed.
    func highlightedCoordinatesDidUpdate() {
        let highlightedCoords = gridViewModel.highlightedCoordinates

        DispatchQueue.main.asyncAfter(deadline: .now() + SlidingGameViewController.highlightDelay) {
            for coord in self.gridView.allCoordinates {
                self.gridView.tileProperties[coord]
                    = { $0.shouldHighlight = highlightedCoords.contains(coord) }
            }
        }
    }
}
