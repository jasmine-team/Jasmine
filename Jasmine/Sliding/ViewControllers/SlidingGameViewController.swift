import UIKit

/// View Controller implementation for Sliding Grid Game.
class SlidingGameViewController: BaseGameViewController {

    // MARK: - Constants
    fileprivate static let highlightDelay = 0.2

    // MARK: - Layouts
    fileprivate var slidingGridView: DraggableSquareGridViewController!

    @IBOutlet fileprivate weak var navigationBar: UINavigationBar!

    // MARK: - Properties
    fileprivate var viewModel: SlidingViewModelProtocol!

    fileprivate var movingTile:
        (tile: SquareTileView, fromCoord: Coordinate, toCoord: [Direction: Coordinate])?

    // MARK: - Segue Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if let slidingGridView = segue.destination as? DraggableSquareGridViewController {
            self.slidingGridView = slidingGridView
            self.slidingGridView.segueWith(viewModel.gridData)
        }
    }

    /// Injects the required data before opening this view.
    ///
    /// - Parameter viewModel: the view model of this class.
    func segueWith(_ viewModel: SlidingViewModelProtocol) {
        super.segueWith(viewModel)

        self.viewModel = viewModel
        self.viewModel.highlightedDelegate = self
    }

    // MARK: Gestures and Listeners
    /// Dismisses this current screen when "Back" button is pressed.
    @IBAction private func onBackPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }

    /// Handles the gesture where the user drags the tile to an empty slot.
    @IBAction private func onTilesDragged(_ sender: UIPanGestureRecognizer) {
        guard viewModel.gameStatus == .inProgress else {
            return
        }

        let position = sender.location(in: slidingGridView.view)
        switch sender.state {
        case .began:
            onTileDraggedBegan(at: position)
        case .changed:
            onTileDragged(to: position)
        case .ended:
            onTileDraggedEnded()
        default:
            break
        }
    }
}

// MARK: - Sliding Tiles
fileprivate extension SlidingGameViewController {

    /// Handles when the tile starts to slide at the specified position.
    fileprivate func onTileDraggedBegan(at position: CGPoint) {
        guard let startingCoord = slidingGridView.getCoordinate(at: position) else {
            return
        }

        let destinations = viewModel.canTileSlide(from: startingCoord)
        guard !destinations.isEmpty else {
            return
        }

        guard let tile = slidingGridView.detachTile(fromCoord: startingCoord) else {
            return
        }

        self.movingTile = (tile, startingCoord, destinations)
    }

    /// Handles when the tile is currently sliding to the specified position.
    /// Also restraints the tile from sliding too far off the allowed coordinates in `movingTile`.
    fileprivate func onTileDragged(to position: CGPoint) {
        guard let movingTile = movingTile,
              let originalPos = slidingGridView.getCenter(from: movingTile.fromCoord) else {
            return
        }

        let finalPosition = position
            .alignToAxis(fromOrigin: originalPos)
            .fitWithin(boundingBox: getBoundingBox(from: movingTile.toCoord, refPoint: originalPos))

        slidingGridView.moveDetachedTile(movingTile.tile, toPosition: finalPosition)
    }

    /// Handles the attachment of tile back to the grid after the sliding is complete.
    fileprivate func onTileDraggedEnded() {
        guard let movingTile = movingTile else {
            return
        }
        self.movingTile = nil

        func helperSnapTile(toCoord coord: Coordinate) {
            slidingGridView.snapDetachedTile(movingTile.tile, toCoordinate: coord) {
                self.slidingGridView.reattachDetachedTile(movingTile.tile)
            }
            SoundService.sharedInstance.play(.snap)
        }

        guard let endingCoord = slidingGridView.getCoordinate(at: movingTile.tile.center),
              viewModel.slideTile(from: movingTile.fromCoord, to: endingCoord) else {

            helperSnapTile(toCoord: movingTile.fromCoord)
            return
        }
        helperSnapTile(toCoord: endingCoord)
    }

    /// Helper method to get the bounding box from the specified `destination` map and the reference
    /// point.
    ///
    /// - Parameters:
    ///   - destination: the destination map of direction, and the further reachable coordinate that
    ///     the tile can be slided to.
    ///   - refPoint: the reference point, which is the starting position of the tile.
    /// - Returns: a bounding rectangle of the area that the tile can be slided.
    private func getBoundingBox(from destination: [Direction: Coordinate], refPoint: CGPoint) -> CGRect {

        /// Helper method to get the center position of the coordinate.
        /// If such a center is not found (maybe cannot slide beyond the initial point), returns
        /// `refPoint` instead.
        func getCenter(from coord: Coordinate?) -> CGPoint {
            guard let coord = coord,
                  let center = slidingGridView.getCenter(from: coord) else {
                return refPoint
            }
            return center
        }

        let northY = getCenter(from: destination[.northwards]).y
        let southY = getCenter(from: destination[.southwards]).y

        let eastX = getCenter(from: destination[.eastwards]).x
        let westX = getCenter(from: destination[.westwards]).x

        return CGRect(minX: westX, maxX: eastX, minY: northY, maxY: southY)
    }
}

extension SlidingGameViewController: HighlightedUpdateDelegate {

    /// Tells the implementor of the delegate that the highlighted coordinates have been changed.
    func highlightedCoordinatesDidUpdate() {
        let highlightedCoords = viewModel.highlightedCoordinates

        DispatchQueue.main.asyncAfter(deadline: .now() + SlidingGameViewController.highlightDelay) {
            for coord in self.slidingGridView.allCoordinates {
                self.slidingGridView.tileProperties[coord] = { tile in
                    tile.shouldHighlight = highlightedCoords.contains(coord)
                }
            }
        }
    }
}
