struct CharacterGrid {
    /// The actual grid.
    private var grid: [[String?]]

    /// Initializes a CharacterGrid, given the initial grid.
    ///
    /// - Parameters:
    ///   - initialGrid: the initial grid. The CharacterGrid will read from this grid.
    ///   - randomized: pass in true if the resulting grid wants to be randomized from the initial grid.
    init(fromInitialGrid initialGrid: [[String]], randomized: Bool) {
        let rows = initialGrid.count
        let columns = initialGrid.first?.count ?? 0
        assert(rows > 0 && columns > 0, "Number of rows and columns should be more than 0")
        assert(initialGrid.map { $0.count }.isAllSame, "All rows should have the same length")

        if randomized {
            let allChars = initialGrid.joined().shuffled()

            let oneRow = [String?](repeating: nil, count: columns)
            var randomizedGrid = [[String?]](repeating: oneRow, count: rows)

            var idx = 0
            for row in 0..<rows {
                for col in 0..<columns {
                    randomizedGrid[row][col] = allChars[idx]
                    idx += 1
                }
            }

            grid = randomizedGrid
        } else {
            grid = initialGrid
        }
    }

    /// Gets the element in the specified coordinate.
    ///
    /// - Parameter coordinate: the coordinate of the element
    subscript(coordinate: Coordinate) -> String? {
        get { return grid[coordinate.row][coordinate.col] }
        set(newString) { grid[coordinate.row][coordinate.col] = newString }
    }

    /// Swaps two elements in the grid, given the two elements' coordinates.
    ///
    /// - Parameters:
    ///   - coord1: the first coordinate
    ///   - coord2: the second coordinate
    mutating func swap(_ coord1: Coordinate, and coord2: Coordinate) {
        let initialSecond = grid[coord2.row][coord2.col]
        grid[coord2.row][coord2.col] = grid[coord1.row][coord1.col]
        grid[coord1.row][coord1.col] = initialSecond
    }

    /// Checks if the grid contains the String array given horizontally.
    ///
    /// - Parameter stringArray: the string array to be checked
    /// - Returns: true if and only if the grid contains the string array horizontally
    func horizontallyContains(stringArray: [String]) -> Bool {
        return grid.contains { row in
            guard row.count >= stringArray.count else {
                return false
            }

            for rowIndex in 0...(row.count - stringArray.count) {
                var inThisRow = true

                for stringIndex in 0..<stringArray.count {
                    guard row[rowIndex + stringIndex] == stringArray[stringIndex] else {
                        inThisRow = false
                        break
                    }
                }

                if inThisRow {
                    return true
                }
            }

            return false
        }
    }
}
