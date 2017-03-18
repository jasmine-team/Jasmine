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

    /* Properties */
    /// Sets the text to be displayed in the UILabel, which derives from the `character` property in
    /// this class.
    ///
    /// Also sets the theme of this class here.
    override var text: String? {
        didSet {
            guard let text = text else {
                setTheme(whenFilled: false)
                return
            }
            setTheme(whenFilled: !text.isEmpty)
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
        layer.borderColor = Constants.Theme.mainColor.cgColor
        layer.borderWidth = SquareTextView.borderWidth
        textColor = Constants.Theme.mainWhiteColor
    }

    private func setTheme(whenFilled: Bool) {
        backgroundColor = whenFilled
                        ? Constants.Theme.mainColor
                        : UIColor.clear
    }

    private func setSquareDimension() {
        let ratioConstraint = NSLayoutConstraint(
            item: self, attribute: .height, relatedBy: .equal, toItem: self, attribute: .width,
            multiplier: SquareTextView.heightWidthRatio, constant: 0)

        addConstraint(ratioConstraint)
    }
}