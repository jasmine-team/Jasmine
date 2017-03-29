import UIKit

/// Displays a view that is square in shape.
/// Capable of displaying a limited number of character(s), including chinese characters.
@IBDesignable
class SquareTileView: UILabel {

    // MARK: Constants
    private static let borderWidth: CGFloat = 2

    // MARK: Text Properties
    /// Sets the text to be displayed in the UILabel, which derives from the `character` property in
    /// this class.
    ///
    /// Also sets the theme of this class here.
    override var text: String? {
        didSet {
            guard let text = text else {
                applyContextualTheme(whenFilled: false)
                return
            }
            applyContextualTheme(whenFilled: !text.isEmpty)
        }
    }

    // MARK: Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)
        applyBaseTheme()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyBaseTheme()
    }

    // MARK: Theming and Styling
    /// A helper method to apply this class with styling.
    private func applyBaseTheme() {
        applyBorder()
        applyFont()
    }

    private func applyBorder() {
        layer.borderColor = Constants.Theme.mainColor.cgColor
        layer.borderWidth = SquareTextView.borderWidth
    }

    private func applyFont() {
        textAlignment = .center
        font = Constants.Theme.tilesFont
        textColor = Constants.Theme.mainWhiteColor
    }

    private func applyContextualTheme(whenFilled: Bool) {
        backgroundColor = whenFilled
                        ? Constants.Theme.mainColor
                        : UIColor.clear
    }
}
