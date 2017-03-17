import UIKit
import ChameleonFramework

/// Displays a view that is square in shape.
/// Capable of displaying a limited number of character(s), including chinese characters.
/// 
/// - Author: Wang Xien Dong
@IBDesignable
class SquareTextView: UILabel {

    /* Constants */
    private static let heightWidthRatio = CGFloat(1.0)
    private static let borderWidth = CGFloat(2.0)
    private static let filledColor = FlatMint()
    private static let emptyColor = UIColor.clear

    /* Properties */
    /// Sets the text to be displayed in the UILabel, which derives from the `character` property in
    /// this class.
    ///
    /// Also sets the theme of this class here.
    override var text: String? {
        didSet {
            if let text = text {
                setTheme(whenFilled: !text.isEmpty)
            } else {
                setTheme(whenFilled: false)
            }
        }
    }

    /* Constructor */
    override init(frame: CGRect) {
        super.init(frame: frame)
        initHelper()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initHelper()
    }

    /// A helper method to initialise this class with styling and dimension.
    private func initHelper() {
        applyBorder()
        setSquareDimension()
    }

    /* Styling Methods */
    private func applyBorder() {
        layer.borderColor = SquareTextView.filledColor.cgColor
        layer.borderWidth = SquareTextView.borderWidth
    }

    private func setTheme(whenFilled: Bool) {
        backgroundColor = whenFilled
                        ? SquareTextView.filledColor
                        : SquareTextView.emptyColor
    }

    private func setSquareDimension() {
        let ratioConstraint = NSLayoutConstraint(
            item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width,
            multiplier: SquareTextView.heightWidthRatio, constant: 0)

        addConstraint(ratioConstraint)
    }
}
