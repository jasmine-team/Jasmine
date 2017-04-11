import XCTest
@testable import Jasmine

class MatrixEquatableTests: XCTestCase {

    func testEquality() {
        let simpleMatrix = [[1, 2], [3, 4]]
        let emptyMatrix: [[Int]] = []
        let rowMatrix = [[1, 2, 3]]
        let columnMatrix = [[1], [2], [3]]
        let weirdMatrix = [[1, 2], [3, 4, 5]]
        let longMatrix = [[1, 2, 3], [4, 5, 6]]
        let allMatrices = [simpleMatrix, emptyMatrix, rowMatrix, columnMatrix, weirdMatrix, longMatrix]

        for (idx1, matrix1) in allMatrices.enumerated() {
            for (idx2, matrix2) in allMatrices.enumerated() {
                XCTAssert((idx1 == idx2) == (matrix1 == matrix2), "Matrix equatable not correct")
            }
        }
    }
}
