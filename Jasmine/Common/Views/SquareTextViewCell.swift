import UIKit

/// Represents a cell in the Square Grid view controller.
///
/// Note that this view cell will instantiate and inject a `SquareTextView` automatically if not done
/// so.
class SquareTextViewCell: UICollectionViewCell {

    // MARK: Properties
    /// Stores the displayed character by displaying it in the label.
    var text: String? {
        set {
            textView?.text = newValue
        }
        get {
            return textView?.text
        }
    }

    /// Gets the label that is kept inside this view cell. If such a view is not found, returns nil.
    var textView: SquareTextView? {
        get {
            return contentView.subviews
                .flatMap { $0 as? SquareTextView }
                .first
        }
        set {
            guard let newTextView = newValue,
                contentView.subviews.isEmpty else {
                    return
            }

            contentView.addSubview(newTextView)
            newTextView.frame = bounds
            contentView.bringSubview(toFront: newTextView)
        }
    }

    /// Automatically enforce that the text view fills the entire boundary of the cell.
    override var bounds: CGRect {
        didSet {
            textView?.frame = bounds
        }
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
        textView = SquareTextView()
        self.clipsToBounds = false
    }
}
