import UIKit
import ChameleonFramework

/// Represents a cell in the Square Grid view controller.
class SquareTextViewCell: UICollectionViewCell {

    // MARK: Properties
    /// Stores the displayed character by displaying it in the label.
    var text: String? {
        set {
            textView.text = newValue
        }
        get {
            return textView.text
        }
    }

    /// Gets the label that is kept inside this view cell.
    ///
    /// An error is thrown if such a label is not found - a sign of wrongly applying this class onto
    /// a view cell.
    private var textView: SquareTextView {
        let possibleView = contentView.subviews
            .flatMap { $0 as? SquareTextView }
            .first
        guard let textView = possibleView else {
            fatalError("This view cell requires a square text view contained in it.")
        }
        return textView
    }

    // MARK: Initialisers
    /// Initialises this view cell and insert a square text view inside.
    convenience init(withText text: String, andFrame frame: CGRect) {
        self.init(frame: frame)

        let squareTextView = SquareTextView()
        squareTextView.text = text
        setConstraints(to: squareTextView)
        addSubview(squareTextView)
    }

    /// Default initialiser for collection view cell.
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    /// Default initialiser for collection view cell.
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: Layout Constraints Methods
    /// Sets the specified view to constraint to the four corners of this view cell.
    ///
    /// - Parameter view: the view to be subjected to constraints.
    private func setConstraints(to view: UIView) {
        for attribute in [NSLayoutAttribute.top, .bottom, .leading, .trailing] {
            let layoutConstraint = NSLayoutConstraint(
                item: view, attribute: attribute, relatedBy: .equal, toItem: self,
                attribute: attribute, multiplier: 0, constant: 0)
            addConstraint(layoutConstraint)
        }
    }
}
