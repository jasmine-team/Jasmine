import XCTest
import UIKit
@testable import Jasmine

class UIApplicationTests: XCTestCase {

    // for use in restoring the key value
    var initialLaunchedBeforeKeyValue: Bool!

    let launchedBeforeKey = Constants.UserDefaultsKeys.launchedBefore.rawValue

    override func setUp() {
        super.setUp()
        // capture initial value for restoring later
        initialLaunchedBeforeKeyValue = UserDefaults.standard.bool(forKey: launchedBeforeKey)
    }

    override func tearDown() {
        super.tearDown()
        // restoring initial value
        UserDefaults.standard.set(initialLaunchedBeforeKeyValue, forKey: launchedBeforeKey)
    }

    func testIsFirstLaunch_firstLaunch() {
        UserDefaults.standard.removeObject(forKey: launchedBeforeKey)
        // sanity check
        XCTAssertFalse(UserDefaults.standard.bool(forKey: launchedBeforeKey), "launched before is not false")
        XCTAssertTrue(UIApplication.isFirstLaunch, "it is launched before")
        XCTAssertFalse(UIApplication.isFirstLaunch, "launched variable is not set to false on second call")
    }

    func testIsFirstLaunch_notFirstLaunched() {
        UserDefaults.standard.set(true, forKey: launchedBeforeKey)
        XCTAssertFalse(UIApplication.isFirstLaunch, "launched variable is not launched before")
    }

}
