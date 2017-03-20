import UIKit

extension UIApplication {

    /// Determines whether this is the first time the user launched the application
    static var isFirstLaunch: Bool {
        let launchedBeforeKey = Constants.UserDefaultsKeys.launchedBefore.rawValue
        let launchedBefore = UserDefaults.standard.bool(forKey: launchedBeforeKey)
        if !launchedBefore {    // set it if not set yet
            UserDefaults.standard.set(true, forKey: launchedBeforeKey)
        }
        return !launchedBefore
    }

}
