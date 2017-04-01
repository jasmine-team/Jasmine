import Foundation
import UIKit
import ChameleonFramework

// MARK: - Drop Shadows
extension UIView {

    /// Adds default drop shadow from this view.
    func addDropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = FlatGrayDark().cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 1.0
    }

    /// Removes any drop shadow from this view.
    func removeDropShadow() {
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowRadius = 0.0
        self.layer.shadowOpacity = 0.0
    }
}
