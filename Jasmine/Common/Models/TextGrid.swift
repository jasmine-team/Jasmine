struct TextGrid {
    /// The actual grid.
    private var grid: [[String?]]

    /// Initializes a CharacterGrid, given the initial grid.
    ///
    /// - Parameters:
    ///   - initialGrid: the initial grid. The CharacterGrid will read from this grid.
    ///   - randomized: pass in true if the resulting grid wants to be randomized from the initial grid.
    init(fromInitialGrid initialGrid: [[String]], randomized: Bool) {
        let numRows = initialGrid.count
        let numColumns = initialGrid.first?.count ?? 0
        assert(numRows > 0 && numColumns > 0, "Number of numRows and columns should be more than 0")
        assert(initialGrid.map { $0.count }.isAllSame, "All numRows should have the same length")

        if randomized {
            let shuffledGrid = initialGrid.joined().shuffled()

            grid = (0..<numRows).map { row in
                (0..<numColumns).map { col in
                    shuffledGrid[row * numColumns + col]
                }
            }
        } else {
            grid = initialGrid
        }
    }

    /// Gets the element in the specified coordinate.
    ///
    /// - Parameter coordinate: the coordinate of the element
    subscript(coordinate: Coordinate) -> String? {
        get { return grid[coordinate.row][coordinate.col] }
        set { grid[coordinate.row][coordinate.col] = newValue }
    }

    /// Swaps two elements in the grid, given the two elements' coordinates.
    ///
    /// - Parameters:
    ///   - coord1: the first coordinate
    ///   - coord2: the second coordinate
    mutating func swap(_ coord1: Coordinate, and coord2: Coordinate) {
        let temp = grid[coord2.row][coord2.col]
        grid[coord2.row][coord2.col] = grid[coord1.row][coord1.col]
        grid[coord1.row][coord1.col] = temp
    }

    /// Checks if the grid contains the String array given horizontally.
    ///
    /// - Parameter stringArray: the string array to be checked
    /// - Returns: true if and only if the grid contains the string array horizontally
    func allRowsInside(stringArrays: [[String]]) -> Bool {
        for row in grid {
            if !stringArrays.contains(where: { $0 == row }) {
                return false
            }
        }

        return true
    }
}
