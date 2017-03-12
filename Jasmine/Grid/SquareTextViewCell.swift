import UIKit
import ChameleonFramework

/// Represents a cell in the Grid Game collections view controller.
/// This view cell assumes that a UILabel is stored within the cell for displaying Chinese character.
///
/// - Author: Wang Xien Dong
class SquareTextViewCell: UICollectionViewCell {

    /* Properties */
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
}
