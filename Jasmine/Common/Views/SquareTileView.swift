import UIKit

/// Displays a view that is square in shape.
/// Capable of displaying a limited number of character(s), including chinese characters.
@IBDesignable
class SquareTileView: UILabel {

    // MARK: Constants
    private static let borderWidth: CGFloat = 2
    private static let fontSizeRatio: CGFloat = 0.618
    private static let highlightAnimation: TimeInterval = 0.4

    // MARK: Properties
    var shouldHighlight = false {
        didSet {
            setHighlightStyle()
        }
    }

    override var frame: CGRect {
        didSet {
            guard frame.size != oldValue.size else {
                return
            }
            adjustFontSize()
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
        applyFont()
        applyDefaultBackground()
    }

    private func applyFont() {
        textAlignment = .center
        font = Constants.Theme.tilesFont
        textColor = Constants.Theme.mainWhiteColor
    }

    private func applyDefaultBackground() {
        backgroundColor = Constants.Theme.mainColor
    }

    private func applyDefaultBorder() {
        self.layer.borderWidth = SquareTileView.borderWidth
        self.layer.backgroundColor = Constants.Theme.mainColor.cgColor
    }

    private func adjustFontSize() {
        guard let numChar = text?.characters.count else {
            return
        }
        font = font.withSize(frame.height * SquareTileView.fontSizeRatio / sqrt(CGFloat(numChar)))
    }

    private func setHighlightStyle() {
        self.backgroundColor = shouldHighlight ? Constants.Theme.secondaryColor : Constants.Theme.mainColor
        self.textColor = shouldHighlight ? Constants.Theme.mainFontColor : Constants.Theme.mainWhiteColor
    }
}
