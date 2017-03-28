import UIKit

/// Represents a cell in the Square Grid view controller.
///
/// Note that this view cell will instantiate and inject a `SquareTextView` automatically if not done
/// so.
class SquareTextViewCell: UICollectionViewCell {

    // MARK: Properties
    /// Stores the displayed text by displaying it in the label.
    /// If the text is nil, the content of this view cell is removed.
    var text: String? {
        get {
            return textView?.text
        }
        set {
            guard let newText = newValue else {
                textView = nil
                return
            }
            if textView == nil {
                textView = SquareTextView()
            }
            textView?.text = newText
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
            // Case: new textView is nil.
            guard let newTextView = newValue else {
                contentView.subviews.forEach { $0.removeFromSuperview() }
                return
            }

            // Case: new textView is present, but viewCell contains another textView.
            guard contentView.subviews.isEmpty else {
                return
            }

            // Otherwise:
            newTextView.frame = bounds
            contentView.addSubview(newTextView)
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
