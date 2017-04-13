import Foundation
import UIKit
import ChameleonFramework

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

    /// Adds a parallax effect to the view with respect to tile of screen
    ///
    /// - Parameters:
    ///   - horizontal: horizontal tilt distance
    ///   - vertical: vertical tilt distance
    func addParallexEffect(horizontal: CGFloat, vertical: CGFloat) {
        let xMotion = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -horizontal
        xMotion.maximumRelativeValue = horizontal

        let yMotion = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -vertical
        yMotion.maximumRelativeValue = vertical

        let motionEffectGroup = UIMotionEffectGroup()
        motionEffectGroup.motionEffects = [xMotion, yMotion]

        addMotionEffect(motionEffectGroup)
    }

    /// Adds a parallax effect to the view with respect to tile of screen
    ///
    /// - Parameter offset: tilt distance
    func addParallexEffect(offset: CGFloat) {
        addParallexEffect(horizontal: offset, vertical: offset)
    }

}
