//
//  GeometryUtilsTest.swift
//  Jasmine
//
//  Created by Xien Dong on 12/3/17.
//  Copyright © 2017 nus.cs3217. All rights reserved.
//

import XCTest
import UIKit
@testable import Jasmine

class GeometryUtilsTest: XCTestCase {

    func testGetOrigin() {

        func testHelper(withPoint center: CGPoint, andSize size: CGSize, expect: CGPoint) {
            let outcome = GeometryUtils.getOrigin(from: center, withSize: size)
            XCTAssertEqual(outcome, expect, "Origin is wrong for \(center) and \(size).")
        }

        // Zero case
        testHelper(withPoint: CGPoint.zero, andSize: CGSize.zero, expect: CGPoint.zero)

        // All positive cases
        testHelper(withPoint: CGPoint.zero, andSize: CGSize(width: 2.0, height: 3.0),
                   expect: CGPoint(x: -1.0, y: -1.5))

        testHelper(withPoint: CGPoint(x: 4, y: 5), andSize: CGSize(width: 10, height: 20),
                   expect: CGPoint(x: -1, y: -5))

        testHelper(withPoint: CGPoint(x: 10, y: 11), andSize: CGSize(width: 1, height: 1),
                   expect: CGPoint(x: 9.5, y: 10.5))

        // Negative Points
        testHelper(withPoint: CGPoint(x: -5, y: -6), andSize: CGSize(width: 2, height: 3),
                   expect: CGPoint(x: -6, y: -7.5))

        testHelper(withPoint: CGPoint(x: -4, y: 0), andSize: CGSize(width: 4, height: 2),
                   expect: CGPoint(x: -6, y: -1))

        testHelper(withPoint: CGPoint(x: 5, y: -10), andSize: CGSize(width: 9, height: 9),
                   expect: CGPoint(x: 0.5, y: -14.5))

        // Invalid size is not tested, because invalid size just does not make sense.
    }

}
