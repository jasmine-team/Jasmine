import UIKit

/// Main view controller for Tetris
class TetrisGameViewController: UIViewController {

    @IBOutlet private var gridCollectionView: UICollectionView!
    @IBOutlet private var upcomingCollectionView: UICollectionView!

    // initialize in viewDidLoad
    fileprivate var gridView: TetrisGridView!
    private var viewModel: TetrisGameViewModelProtocol!
    fileprivate var cellSize: CGFloat!

    fileprivate var movingTileView: TetrisTileView?

    // MARK: Upcoming and Falling Tile
    /// Gets the position of the falling tile. If such a position is not available, returns nil.
    var fallingTilePosition: Coordinate?

    override func viewDidLoad() {
        super.viewDidLoad()

        gridCollectionView.dataSource = self
        gridCollectionView.delegate = self
        gridView = TetrisGridView(gridCollectionView)

        setupTapGesture()
    }

    // Engine is initialized here as updates to UICollectionViewCell is only possible after this
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel = TetrisGameViewModel()
        viewModel.delegate = self
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        view.addGestureRecognizer(tapGesture)
    }

    @objc
    private func tapHandler(_ recognizer: UITapGestureRecognizer) {
    }
}

/// MARK: - TetrisViewDelegate
extension TetrisGameViewController: TetrisGameViewControllerDelegate {

    func notifyGameStatus() {}

    func redisplayUpcomingTiles() {}

    func redisplayFallingTile(tileText: String) {}

    func animate(destroyTilesAt coodinates: Set<Coordinate>) {}

    func animate(shiftTiles coordinatesToShift: [(from: Coordinate, to: Coordinate)]) {}

    func redisplay(newScore: Int) {}

    func redisplay(timeRemaining: TimeInterval, outOf totalTime: TimeInterval) {}

    func notifyGameStatus(with newStatus: GameStatus) {}
}

/// MARK: - UICollectionViewDataSource
extension TetrisGameViewController: UICollectionViewDataSource {

    // every section comprises a row of tiles,
    // while the column index of the tile is given by IndexPath.row
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return Constants.Tetris.columns
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Constants.Tetris.rows
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.Tetris.cellIdentifier, for: indexPath)

        // todo: remove these temp code (for visualization only)
        cell.layer.borderWidth = 1.0
        let label = UILabel()
        label.frame.size = CGSize(width: cell.frame.width, height: cell.frame.height / 3)
        label.text = "r:" + String(indexPath.row) + " s:" + String(indexPath.section)
        label.font = label.font.withSize(12)
        cell.contentView.addSubview(label)

        return cell
    }

}

/// MARK: - UICollectionViewDelegateFlowLayout
extension TetrisGameViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        cellSize = collectionView.frame.width / CGFloat(Constants.Tetris.columns)
        return CGSize(width: cellSize, height: cellSize)
    }

}
