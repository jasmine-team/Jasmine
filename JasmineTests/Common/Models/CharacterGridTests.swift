import XCTest
@testable import Jasmine

class CharacterGridTests: XCTestCase {
    func testInitFromInitialGrid() {
        let initialGrid = [["a", "b"], ["c", "d"]]
        let grid = CharacterGrid(fromInitialGrid: initialGrid, randomized: false)

        for row in 0..<2 {
            for col in 0..<2 {
                XCTAssertEqual(initialGrid[row][col],
                               grid[Coordinate(row: row, col: col)],
                               "Grid is not initialized properly")
            }
        }
    }

    func testInitFromInitialGridRandomized() {
        let initialGrid = [["a", "b"], ["c", "d"]]
        let grid = CharacterGrid(fromInitialGrid: initialGrid, randomized: true)

        var allCharacters = initialGrid.flatMap { $0 }

        for row in 0..<2 {
            for col in 0..<2 {
                let elem = grid[Coordinate(row: row, col: col)]
                XCTAssert(allCharacters.contains { $0 == elem },
                          "Grid is not initialized properly")
                allCharacters = allCharacters.filter { $0 != elem }
            }
        }
    }

    func testSubscriptSet() {
        let initialGrid = [["a", "b", "c"], ["d", "e", "f"]]
        var grid = CharacterGrid(fromInitialGrid: initialGrid, randomized: false)

        grid[Coordinate(row: 0, col: 0)] = "f"

        let resultingGrid = [["f", "b", "c"], ["d", "e", "f"]]
        for row in 0..<2 {
            for col in 0..<3 {
                let elem = grid[Coordinate(row: row, col: col)]
                XCTAssertEqual(resultingGrid[row][col], elem,
                               "Grid is not initialized properly")
            }
        }
    }

    func testSwap() {
        let initialGrid = [["a", "b", "c"], ["d", "e", "f"]]
        var grid = CharacterGrid(fromInitialGrid: initialGrid, randomized: false)

        grid.swap(Coordinate(row: 0, col: 1), and: Coordinate(row: 1, col: 2))

        let resultingGrid = [["a", "f", "c"], ["d", "e", "b"]]
        for row in 0..<2 {
            for col in 0..<3 {
                let elem = grid[Coordinate(row: row, col: col)]
                XCTAssertEqual(resultingGrid[row][col], elem,
                               "Grid is not initialized properly")
            }
        }
    }

    func testHorizontallyContains() {
        let initialGrid = [["a", "b", "c"], ["d", "e", "f"]]
        let grid = CharacterGrid(fromInitialGrid: initialGrid, randomized: false)

        for startElem in 0..<3 {
            for endElem in startElem..<3 {
                let firstRowSlice = Array(initialGrid[0][startElem...endElem])
                let secondRowSlice = Array(initialGrid[1][startElem...endElem])

                XCTAssert(grid.horizontallyContains(stringArray: firstRowSlice),
                          "Grid doesn't horizontally contain \(firstRowSlice)")
                XCTAssert(grid.horizontallyContains(stringArray: secondRowSlice),
                          "Grid doesn't horizontally contain \(secondRowSlice)")
            }
        }

        XCTAssertFalse(grid.horizontallyContains(stringArray: ["g", "h"]),
                       "Grid doesn't horizontally contain the string array")
        XCTAssertFalse(grid.horizontallyContains(stringArray: ["g"]),
                       "Grid doesn't horizontally contain the string array")
    }
}
