import UIKit

/// Adds a tap gesture recogniser to make this grid view controller selectable.
class SelectableSquareGridViewController: SquareGridViewController {

    // MARK: - Listeners
    var onTileSelected: ((Coordinate) -> Void)?

    // MARK: - View Controller Lifecycle
    /// Adds a tap gesture recogniser to this view.
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTouch(_:)))
        self.view.addGestureRecognizer(tapGesture)
    }

    /// Handles the touch event by executing the callback set by `onTileSelected`.
    @objc
    private func handleTouch(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        guard let coordinate = getCoordinate(at: location) else {
            return
        }
        self.onTileSelected?(coordinate)
    }
}
