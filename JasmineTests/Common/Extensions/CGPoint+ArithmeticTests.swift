import XCTest
@testable import Jasmine

class CGPointArithmeticTests: XCTestCase {

    func testSub() {
        XCTAssertEqual(CGPoint.zero.sub(.zero), CGVector.zero,
                       "Zero vector expected.")
        XCTAssertEqual(CGPoint(x: 10, y: 10).sub(CGPoint(x: 5, y: 5)), CGVector(dx: 5, dy: 5),
                       "Incorrect resultant vector produced.")
        XCTAssertEqual(CGPoint(x: 5, y: -5).sub(CGPoint(x: -15, y: 15)), CGVector(dx: 20, dy: -20),
                       "Incorrect resultant vector produced.")
    }

    func testFitWithin() {
        /// Helper method that helps to test the fitWithin method with the point that should be 
        /// fitted into, and the four boundaries.
        func testHelper(point: CGPoint, expected: CGPoint, boundingRect: CGRect) {
            let outcome = point.fitWithin(boundingBox: boundingRect)
            XCTAssertEqual(outcome, expected, "The produced point by fitWithin is wrong.")
        }

        testHelper(point: CGPoint(x: 1, y: 2), expected: .zero,
                   boundingRect: CGRect(minX: 0, maxX: 0, minY: 0, maxY: 0))

        testHelper(point: CGPoint(x: 3, y: 5), expected: CGPoint(x: 3, y: 3),
                   boundingRect: CGRect(minX: 0, maxX: 3, minY: 0, maxY: 3))

        testHelper(point: CGPoint(x: -10, y: -15), expected: CGPoint(x: -4, y: -4),
                   boundingRect: CGRect(minX: -4, maxX: 3, minY: -4, maxY: 3))
    }

    func testAlignToAxis() {
        /// Helper test to test if aligning to axis is correct.
        func testHelper(point: CGPoint, origin: CGPoint, expected: CGPoint) {
            XCTAssertEqual(point.alignToAxis(fromOrigin: origin), expected, "alignment incorrect!")
        }

        testHelper(point: CGPoint(x: 10, y: 10), origin: CGPoint(x: 10, y: 10),
                   expected: CGPoint(x: 10, y: 10))

        testHelper(point: CGPoint(x: 20, y: 10), origin: CGPoint(x: 10, y: 10),
                   expected: CGPoint(x: 20, y: 10))

        testHelper(point: CGPoint(x: -20, y: 10), origin: CGPoint(x: 10, y: 10),
                   expected: CGPoint(x: -20, y: 10))

        testHelper(point: CGPoint(x: 10, y: 20), origin: CGPoint(x: 10, y: 10),
                   expected: CGPoint(x: 10, y: 20))

        testHelper(point: CGPoint(x: 10, y: -10), origin: CGPoint(x: 10, y: 10),
                   expected: CGPoint(x: 10, y: -10))

        testHelper(point: CGPoint(x: 11, y: 20), origin: CGPoint(x: 10, y: 10),
                   expected: CGPoint(x: 10, y: 20))

        testHelper(point: CGPoint(x: 16, y: 11), origin: CGPoint(x: 10, y: 10),
                   expected: CGPoint(x: 16, y: 10))

        testHelper(point: CGPoint(x: 9, y: -11), origin: CGPoint(x: 10, y: 10),
                   expected: CGPoint(x: 10, y: -11))
    }
}
