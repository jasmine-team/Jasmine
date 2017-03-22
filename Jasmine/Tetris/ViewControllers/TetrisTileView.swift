import UIKit

/// Represents the view for a tile
class TetrisTileView: UILabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    init(_ word: Character, size: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        text = String(word)
        textAlignment = .center
        font = font.withSize(size)
    }

}
