import XCTest
@testable import Jasmine

class TextGridTests: XCTestCase {
    func testInitFromInitialGrid() {
        let initialGrid = [["a", nil, "c"], ["d", "e", "f"], ["g", "h", nil], [nil, nil, nil]]
        let grid = TextGrid(fromInitialGrid: initialGrid)

        for row in 0..<4 {
            for col in 0..<3 {
                XCTAssertEqual(initialGrid[row][col],
                               grid[Coordinate(row: row, col: col)],
                               "Grid is not initialized properly")
            }
        }
    }

    func testNumRowsColumns() {
        let initialGrid = [["a", nil, "c"], ["d", "e", "f"], ["g", "h", nil], [nil, nil, nil]]
        let grid = TextGrid(fromInitialGrid: initialGrid)

        XCTAssertEqual(4, grid.numRows,
                       "Number of rows not correct")
        XCTAssertEqual(3, grid.numColumns,
                       "Number of columns not correct")
    }

    func testCoordinateDictionary() {
        let initialGrid = [["a", nil, "c"], ["d", "e", "f"], ["g", "h", nil], [nil, nil, nil]]
        let grid = TextGrid(fromInitialGrid: initialGrid)

        var coordinateDictionary: [Coordinate: String] = [:]
        for row in 0..<initialGrid.count {
            for col in 0..<initialGrid[0].count {
                coordinateDictionary[Coordinate(row: row, col: col)] = initialGrid[row][col]
            }
        }

        XCTAssertEqual(grid.coordinateDictionary, coordinateDictionary,
                       "Coordinate dictionary representation not correct")
    }

    func testSubscriptSet() {
        let initialGrid = [["a", "b", "c"], ["d", "e", "f"]]
        var grid = TextGrid(fromInitialGrid: initialGrid)

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
        var grid = TextGrid(fromInitialGrid: initialGrid)

        grid.swap(Coordinate(row: 0, col: 1), Coordinate(row: 1, col: 2))

        let resultingGrid = [["a", "f", "c"], ["d", "e", "b"]]
        for row in 0..<2 {
            for col in 0..<3 {
                let elem = grid[Coordinate(row: row, col: col)]
                XCTAssertEqual(resultingGrid[row][col], elem,
                               "Grid is not initialized properly")
            }
        }
    }
}
