import UIKit

// MARK: - All Subviews
extension UIView {

    /// Obtains all the subviews nested in this view.
    var allSubviews: [UIView] {
        var views = subviews
        views.forEach { views.append(contentsOf: $0.allSubviews) }
        return views
    }
}
