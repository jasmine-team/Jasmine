import XCTest
@testable import Jasmine

class TextGridTests: XCTestCase {
    func testInitFromInitialGrid() {
        let initialGrid = [["a", nil, "c"], ["d", "e", "f"], ["g", "h", nil], [nil, nil, nil]]
        let grid = TextGrid(fromInitialGrid: initialGrid, randomized: false)

        for row in 0..<4 {
            for col in 0..<3 {
                XCTAssertEqual(initialGrid[row][col],
                               grid[Coordinate(row: row, col: col)],
                               "Grid is not initialized properly")
            }
        }
    }

    func testInitFromInitialGridRandomized() {
        let initialGrid = [["a", "b"], ["c", "d"]]
        let grid = TextGrid(fromInitialGrid: initialGrid, randomized: true)

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
        var grid = TextGrid(fromInitialGrid: initialGrid, randomized: false)

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
        var grid = TextGrid(fromInitialGrid: initialGrid, randomized: false)

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

    func testAllRowsInside() {
        let initialGrid = [["a", "b", "c"], ["d", "e", "f"]]
        let grid = TextGrid(fromInitialGrid: initialGrid, randomized: false)

        XCTAssert(grid.allRowsInside(stringArrays: initialGrid),
                  "Grid allRowsInside not working properly")
        XCTAssert(grid.allRowsInside(stringArrays: [["a", "b", "c"], ["d", "e", "f"], ["g", "h", "i"]]),
                  "Grid allRowsInside not working properly")
        XCTAssertFalse(grid.allRowsInside(stringArrays: [["a", "b", "c"]]),
                  "Grid allRowsInside not working properly")
        XCTAssertFalse(grid.allRowsInside(stringArrays: [["d", "e", "f"]]),
                  "Grid allRowsInside not working properly")
        XCTAssertFalse(grid.allRowsInside(stringArrays: [["c", "b", "a"], ["d", "e", "f"]]),
                  "Grid allRowsInside not working properly")
        XCTAssertFalse(grid.allRowsInside(stringArrays: [["a", "b", "c", "x"], ["d", "e", "f"]]),
                  "Grid allRowsInside not working properly")
    }
}
