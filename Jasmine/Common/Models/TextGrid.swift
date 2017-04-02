/// An encapsulation of a grid of strings, mapping a Coordinate to a String.
struct TextGrid {
    /// The actual grid.
    private var grid: [[String?]]

    /// The number of rows in the grid.
    var numRows: Int {
        return grid.count
    }

    /// The number of columns in the grid.
    var numColumns: Int {
        return grid.first?.count ?? 0
    }

    /// Initializes a TextGrid, given the initial grid.
    ///
    /// - Parameters:
    ///   - initialGrid: the initial grid. The CharacterGrid will read from this grid.
    init(fromInitialGrid initialGrid: [[String?]]) {
        let numRows = initialGrid.count
        let numColumns = initialGrid.first?.count ?? 0
        assert(numRows > 0 && numColumns > 0, "Number of numRows and columns should be more than 0")

        grid = initialGrid
    }

    /// Initializes with an empty grid.
    init() {
        self.init(fromInitialGrid: [])
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
    mutating func swap(_ coord1: Coordinate, _ coord2: Coordinate) {
        Swift.swap(&grid[coord1.row][coord1.col], &grid[coord2.row][coord2.col])
    }

    /// Returns the [Coordinate: String] representation of this grid.
    var coordinateDictionary: [Coordinate: String] {
        var result: [Coordinate: String] = [:]
        for row in 0..<numRows {
            for col in 0..<numColumns {
                result[Coordinate(row: row, col: col)] = grid[row][col]
            }
        }
        return result
    }
}
