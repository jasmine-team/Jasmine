import UIKit

/// Represents a cell in the Grid Game collections view controller.
/// This view cell assumes that a UILabel is stored within the cell for displaying Chinese character.
///
/// - Author: Wang Xien Dong
class GridCharacterViewCell: UICollectionViewCell {

    /// Stores the displayed character by displaying it in the label.
    var chineseCharacter: Character? {
        set {
            guard let newCharacter = newValue else {
                return
            }
            chineseCharacterLabel.text = "\(newCharacter)"
        }
        get {
            return chineseCharacterLabel.text?
                .characters
                .first
        }
    }

    /// Gets the label that is kept inside this view cell.
    ///
    /// An error is thrown if such a label is not found - a sign of wrongly applying this class onto
    /// a view cell.
    private var chineseCharacterLabel: UILabel {
        let possibleLabel = contentView.subviews
            .flatMap { $0 as? UILabel }
            .first
        guard let label = possibleLabel else {
            fatalError("This view cell requires a label contained in it.")
        }
        return label
    }
}
