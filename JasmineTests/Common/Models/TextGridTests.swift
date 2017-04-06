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

    func testInitFromInitialRow() {
        let initialRow = ["a", "b", "c", "d", nil, "f", "g"]
        let grid = TextGrid(fromInitialRow: initialRow)
        XCTAssertEqual(grid.numRows, 1, "Number of rows is wrong.")
        XCTAssertEqual(grid.numColumns, 7, "Number of columns is wrong.")
        for col in 0..<7 {
            XCTAssertEqual(initialRow[col], grid[Coordinate(row: 0, col: col)], "Value is wrong.")
        }
    }

    func testInitFromInitialCol() {
        let initialCol = ["a", "b", "c", "d", nil, "f", "g"]
        let grid = TextGrid(fromInitialCol: initialCol)
        XCTAssertEqual(grid.numRows, 7, "Number of rows is wrong.")
        XCTAssertEqual(grid.numColumns, 1, "Number of columns is wrong.")
        for row in 0..<7 {
            XCTAssertEqual(initialCol[row], grid[Coordinate(row: row, col: 0)], "Value is wrong.")
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

    func testHasText() {
        var grid = TextGrid(numRows: 10, numColumns: 8)
        let coordinate = Coordinate(row: 1, col: 1)
        grid[coordinate] = "test"
        XCTAssertFalse(grid.hasText(at: Coordinate(row: 0, col: 0)), "hasText returns false positive")
        XCTAssert(grid.hasText(at: coordinate), "hasText returns false negative")
    }

    func testRemoveTexts() {
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
        let grid = TextGrid(fromInitialGrid: initialGrid)
        guard let texts = grid.getTexts(at: [Coordinate(row: 1, col: 0), Coordinate(row: 1, col: 1)]) else {
            XCTAssert(false, "Failed to get texts")
            return
        }
        XCTAssertEqual(texts, ["c", "d"], "Retrieved wrong texts")
    }

    func testGetTextsNil() {
        let initialGrid = [["a", nil], ["c", "d"]]
        let grid = TextGrid(fromInitialGrid: initialGrid)
        XCTAssertNil(grid.getTexts(at: [Coordinate(row: 0, col: 0), Coordinate(row: 0, col: 1)]),
                     "Did not return nil when there's no text at a coordinate")
    }

    func testGetConcatenatedTexts() {
        let initialGrid = [["a", "b"], ["c", "d"]]
        let grid = TextGrid(fromInitialGrid: initialGrid)
        guard let texts = grid.getConcatenatedTexts(at: [Coordinate(row: 1, col: 0), Coordinate(row: 1, col: 1)]) else {
            XCTAssert(false, "Failed to get texts")
            return
        }
        XCTAssertEqual(texts, "cd", "Retrieved wrong texts")
    }

    func testGetConcatenatedTextsWithSeparator() {
        let initialGrid = [["a", "b"], ["c", "d"]]
        let grid = TextGrid(fromInitialGrid: initialGrid)
        guard let texts = grid.getConcatenatedTexts(at: [Coordinate(row: 1, col: 0), Coordinate(row: 1, col: 1)],
                                                    separatedBy: "x") else {
            XCTAssert(false, "Failed to get texts")
            return
        }
        XCTAssertEqual(texts, "cxd", "Retrieved wrong texts")
    }

    func testGetConcatenatedTextsWithSeparatorNil() {
        let initialGrid = [["a", nil], ["c", "d"]]
        let grid = TextGrid(fromInitialGrid: initialGrid)
        XCTAssertNil(grid.getConcatenatedTexts(at: [Coordinate(row: 0, col: 0), Coordinate(row: 0, col: 1)],
                                               separatedBy: "qwer"),
                     "Did not return nil when there's no text at a coordinate")
    }

    func testIsInBounds() {
        let gridSize = 4

        let grid = TextGrid(numRows: gridSize, numColumns: gridSize)

        for row in -3...10 {
            for col in -3...10 {
                let coordinate = Coordinate(row: row, col: col)
                XCTAssertEqual((0 <= row && row < gridSize && 0 <= col && col < gridSize),
                               grid.isInBounds(coordinate: coordinate),
                               "\(coordinate) is in 4x4 grid")
            }
        }
    }

    func testCount() {
        for (row, col) in [(1, 1), (1, 2), (1, 100), (2, 1), (100, 1), (33, 55)] {
            XCTAssertEqual(row * col,
                           TextGrid(numRows: row, numColumns: col).count,
                           "Count not correct")
        }
    }
}
