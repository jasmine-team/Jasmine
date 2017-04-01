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

    func testInitFromNumRowsAndColumns() {
        let numRows = 10
        let numColumns = 8
        let grid = TextGrid(numRows: numRows, numColumns: numColumns)
        XCTAssertEqual(grid.numRows, numRows)
        XCTAssertEqual(grid.numColumns, numColumns)
        for row in 0..<numRows {
            for col in 0..<numColumns {
                XCTAssertNil(grid[Coordinate(row: row, col: col)], "Initialized grid is not nil")
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

        grid.swap(coord1: Coordinate(row: 0, col: 1), coord2: Coordinate(row: 1, col: 2))

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

    func testHasText() {
        var grid = TextGrid(numRows: 10, numColumns: 8)
        let coordinate = Coordinate(row: 1, col: 1)
        grid[coordinate] = "test"
        XCTAssertFalse(grid.hasText(at: Coordinate(row: 0, col: 0)), "hasText returns false positive")
        XCTAssert(grid.hasText(at: coordinate), "hasText returns false negative")
    }

    func removeTexts() {
        var grid = TextGrid(numRows: 10, numColumns: 8)
        var coordinatesToRemove: Set<Coordinate> = []
        coordinatesToRemove.insert(Coordinate(row: 1, col: 1))
        coordinatesToRemove.insert(Coordinate(row: 0, col: 0))
        let coordinateToRetain = Coordinate(row: 0, col: 1)
        grid[coordinateToRetain] = "test"
        for coordinate in coordinatesToRemove {
            grid[coordinate] = "test"
        }
        grid.removeTexts(at: coordinatesToRemove)

        for coordinate in coordinatesToRemove {
            XCTAssertFalse(grid.hasText(at: coordinate), "Failed to remove text")
        }
        XCTAssert(grid.hasText(at: coordinateToRetain), "Wrong text removed")
    }

    func testGetTexts() {
        let initialGrid = [["a", "b"], ["c", "d"]]
        let grid = TextGrid(fromInitialGrid: initialGrid, randomized: false)
        guard let texts = grid.getTexts(at: [Coordinate(row: 1, col: 0), Coordinate(row: 1, col:1)]) else {
            XCTAssert(false, "Failed to get texts")
            return
        }
        XCTAssertEqual(texts, ["c", "d"], "Retrieved wrong texts")
    }

    func testGetTextsNil() {
        let initialGrid = [["a", nil], ["c", "d"]]
        let grid = TextGrid(fromInitialGrid: initialGrid, randomized: false)
        XCTAssertNil(grid.getTexts(at: [Coordinate(row: 0, col: 0), Coordinate(row: 0, col:1)]),
                     "Did not return nil when there's no text at a coordinate")
    }

    func testGetConcatenatedTexts() {
        let initialGrid = [["a", "b"], ["c", "d"]]
        let grid = TextGrid(fromInitialGrid: initialGrid, randomized: false)
        guard let texts = grid.getConcatenatedTexts(at: [Coordinate(row: 1, col: 0), Coordinate(row: 1, col:1)]) else {
            XCTAssert(false, "Failed to get texts")
            return
        }
        XCTAssertEqual(texts, "cd", "Retrieved wrong texts")
    }

    func testGetConcatenatedTextsNil() {
        let initialGrid = [["a", nil], ["c", "d"]]
        let grid = TextGrid(fromInitialGrid: initialGrid, randomized: false)
        XCTAssertNil(grid.getTexts(at: [Coordinate(row: 0, col: 0), Coordinate(row: 0, col:1)]),
                     "Did not return nil when there's no text at a coordinate")
    }
}
