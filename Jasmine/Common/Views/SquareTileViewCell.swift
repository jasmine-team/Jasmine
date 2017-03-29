import UIKit
import SnapKit

/// Represents a cell in the Square Grid view controller.
/// This cell can hold more than one `SquareTileView` tile.
class SquareTileViewCell: UICollectionViewCell {

    // MARK: Properties
    /// Gets the tiles that are stored in this view cell, where the first index is the top-most 
    /// tile.
    var tiles: [SquareTileView] {
        return contentView.subviews
            .reversed()
            .flatMap { $0 as? SquareTileView }
    }

    /// Gets the top-most tile that is currently displayed in view.
    /// Does not modify all the tiles below.
    var displayedTile: SquareTileView? {
        return contentView.subviews.last as? SquareTileView
    }

    /// Sets the displayed text by setting it on the top most tile.
    /// Does not modify all the tiles below.
    var displayedText: String? {
        return displayedTile?.text
    }

    // MARK: Tile Stack
    /// Pushes a tile to the top of the cell view stack.
    func pushTileToTop(_ tile: SquareTileView) {
        contentView.addSubview(tile)
        tile.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentView.bringSubview(toFront: tile)
    }

    /// Pushes a text that will be placed in a tile to the top of the cell view stack.
    func pushTextToTop(_ text: String) -> SquareTileView {
        let tile = SquareTileView()
        tile.text = text
        pushTileToTop(tile)
        return tile
    }

    /// Removes a tile from the top of the cell view stack
    @discardableResult func popTileFromTop() -> SquareTileView? {
        guard let tile = displayedTile else {
            return nil
        }
        tile.removeFromSuperview()
        tile.snp.removeConstraints()
        return tile
    }

    /// Clears all the tiles stored in this cell.
    func clearAllTiles() {
        tiles.forEach { $0.removeFromSuperview() }
    }

    // MARK: With One Tile Only
    func setOnlyTile(_ tile: SquareTileView?) {
        clearAllTiles()
        guard let tile = tile else {
            return
        }
        pushTileToTop(tile)
    }

    @discardableResult func setOnlyText(_ text: String?) -> SquareTileView? {
        clearAllTiles()
        guard let text = text else {
            return nil
        }
        return pushTextToTop(text)
    }

    // MARK: Initialisers
    /// Default initialiser for collection view cell.
    override init(frame: CGRect) {
        super.init(frame: frame)
        initHelper()
    }

    /// Default initialiser for collection view cell.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initHelper()
    }

    private func initHelper() {
        self.clipsToBounds = false
    }
}
