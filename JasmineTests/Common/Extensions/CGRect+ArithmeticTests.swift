import XCTest
import UIKit
@testable import Jasmine

class CGRectArithmeticTests: XCTestCase {

    func testOriginAndCenter() {

        func testHelper(withPoint center: CGPoint, size: CGSize, andOrigin origin: CGPoint) {

            // Assert that with center and size, origin is correct.
            let originOutcome = CGRect(center: center, size: size)
            XCTAssertEqual(originOutcome.origin, origin, "Origin is wrong for \(center) and \(size).")

            // Assert that with origin and size, center is correct.
            let centerOutcome = CGRect(origin: origin, size: size)
            XCTAssertEqual(centerOutcome.center, center, "Origin is wrong for \(origin) and \(size).")

        }

        // Zero case
        testHelper(withPoint: CGPoint.zero, size: CGSize.zero, andOrigin: CGPoint.zero)

        // All positive cases
        testHelper(withPoint: CGPoint.zero, size: CGSize(width: 2.0, height: 3.0),
                   andOrigin: CGPoint(x: -1.0, y: -1.5))

        testHelper(withPoint: CGPoint(x: 4, y: 5), size: CGSize(width: 10, height: 20),
                   andOrigin: CGPoint(x: -1, y: -5))

        testHelper(withPoint: CGPoint(x: 10, y: 11), size: CGSize(width: 1, height: 1),
                   andOrigin: CGPoint(x: 9.5, y: 10.5))

        // Negative Points
        testHelper(withPoint: CGPoint(x: -5, y: -6), size: CGSize(width: 2, height: 3),
                   andOrigin: CGPoint(x: -6, y: -7.5))

        testHelper(withPoint: CGPoint(x: -4, y: 0), size: CGSize(width: 4, height: 2),
                   andOrigin: CGPoint(x: -6, y: -1))

        testHelper(withPoint: CGPoint(x: 5, y: -10), size: CGSize(width: 9, height: 9),
                   andOrigin: CGPoint(x: 0.5, y: -14.5))

        // Invalid size is not tested, because invalid size is not guarded in CGRect by Apple,
        // and is treated as undetermined behaviour instead.
    }
}
