//  Created by Xien Dong on 22/2/17.
//  Copyright © 2017 Xien Dong. All rights reserved.

import Foundation
import UIKit


extension UIImageView {
    
    /// Helper method that animates the given frames only once, and stops the animation
    /// on the last frame.
    ///
    /// - Parameters:
    ///   - frames: the set of images used for animation.
    ///   - durationPerFrame: the duration, in seconds, for each frame.
    func animateOnce(with frames: [UIImage], and durationPerFrame: TimeInterval) {
        animateOnce(with: frames, lastFrame: frames.last, and: durationPerFrame)
    }
    
    /// Helper method that animates the given frames only once, and stops the animation
    /// on the last frame.
    ///
    /// If last frame is not supplied, displays nothing.
    ///
    /// - Parameters:
    ///   - frames: the set of images used for animation.
    ///   - lastFrame: the final resting frame to display.
    ///   - durationPerFrame: the duration, in seconds, for each frame.
    func animateOnce(with frames: [UIImage], lastFrame: UIImage?,
                     and durationPerFrame: TimeInterval) {
        let repeatCount = 1
        
        self.image = lastFrame
        self.animationImages = frames
        self.animationRepeatCount = repeatCount
        self.animationDuration = durationPerFrame * TimeInterval(frames.count)
        self.startAnimating()
    }
    
}
