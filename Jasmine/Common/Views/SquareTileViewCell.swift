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

    override var bounds: CGRect {
        didSet {
            tiles.forEach { $0.frame = bounds }
        }
    }

    private let animationView = UIImageView()

    // MARK: Tile Properties
    /// Set this method to set the properties to all the tiles in this cell.
    var tileProperties: ((SquareTileView) -> Void)? {
        didSet {
            guard tileProperties != nil || oldValue != nil else {
                return
            }
            guard let tileProperties = tileProperties else {
                resetTiles()
                return
            }
            tiles.forEach { tileProperties($0) }
        }
    }

    /// Applies the tile properties function to all the tiles in this view cell.
    func applyTileProperties() {
        guard let tileProperties = tileProperties else {
            return
        }
        tiles.forEach { tileProperties($0) }
    }

    // MARK: Tile Stack
    /// Pushes a tile to the top of the cell view stack.
    /// - Postcondition: 
    ///   - The tile's properties will be automatically applied with `setTileProperties`
    ///   - The tile's size is set after this method is called.
    /// - Note:
    ///   - All other methods that involve adding a tile will involve calling this method.
    func pushTileToTop(_ tile: SquareTileView) {
        contentView.addSubview(tile)
        contentView.bringSubview(toFront: tile)
        tileProperties?(tile)
        tile.frame = bounds
    }

    /// Pushes a text that will be placed in a tile to the top of the cell view stack.
    func pushTextToTop(_ text: String?) -> SquareTileView {
        let tile = SquareTileView()
        tile.text = text
        pushTileToTop(tile)
        return tile
    }

    /// Removes a tile from the top of the cell view stack
    @discardableResult
    func popTileFromTop() -> SquareTileView? {
        guard let tile = displayedTile else {
            return nil
        }
        tile.removeFromSuperview()
        return tile
    }

    /// Clears all the tiles stored in this cell.
    func clearAllTiles() {
        tiles.forEach { $0.removeFromSuperview() }
    }

    /// Clear all the tiles except the top most tile in this cell.
    func clearExceptFirst() {
        tiles.forEach {
            guard $0 != displayedTile else {
                return
            }
            $0.removeFromSuperview()
        }
    }

    // MARK: With One Tile Only
    func setOnlyTile(_ tile: SquareTileView?) {
        clearAllTiles()
        guard let tile = tile else {
            return
        }
        pushTileToTop(tile)
    }

    @discardableResult
    func setOnlyText(_ text: String?) -> SquareTileView? {
        clearAllTiles()
        guard let text = text else {
            return nil
        }
        return pushTextToTop(text)
    }

    // MARK: Animations
    func animateExplosion() {
        guard let displayedTile = displayedTile else {
            return
        }
        clearExceptFirst()
        animationView.animateOnce(with: Constants.Graphics.Explosion.frames, lastFrame: nil,
                                  and: Constants.Graphics.Explosion.interval)

        UIView.animate(withDuration: Constants.Graphics.Explosion.duration,
                       animations: { displayedTile.alpha = 0.0 },
                       completion: { _ in displayedTile.removeFromSuperview() })
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

    // MARK: Helper methods
    private func initHelper() {
        self.clipsToBounds = false
        self.backgroundColor = Constants.Theme.cellsBackground
        self.setUpAnimationView()
    }

    private func setUpAnimationView() {
        self.addSubview(animationView)
        self.sendSubview(toBack: animationView)
        self.animationView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    private func resetTiles() {
        let oldTiles = tiles
        clearAllTiles()
        oldTiles.reversed()
            .forEach { _ = pushTextToTop($0.text) }
    }
}
