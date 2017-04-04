/// An encapsulation of a grid of strings, mapping a Coordinate to a String.
/// Stores text as String instead of Character to allow pinyin as text
struct TextGrid {
    /// The actual grid.
    private var grid: [[String?]]

    /// The number of rows in the grid.
    var numRows: Int {
        return grid.count
    }

    /// The number of columns in the grid.
    var numColumns: Int {
        return grid[0].count
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

    /// Initializes a TextGrid with a given initial array. Produces a grid of a single row.
    ///
    /// - Parameter initalArray: the initial array to be morphed into a grid.
    init(fromInitialArray initalArray: [String?]) {
        self.init(fromInitialGrid: [initalArray])
    }

    /// Initializes a TextGrid filled with nils, given the dimensions of the grid.
    ///
    /// - Parameters:
    ///   - numRows: number of rows in the grid
    ///   - numCols: number of columns in the grid
    init(numRows: Int, numColumns: Int) {
        assert(numRows > 0 && numColumns > 0, "Number of numRows and columns should be more than 0")

        grid = [[String?]](repeating: [String?](repeating: nil, count: numColumns), count: numRows)
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
        Swift.swap(&self[coord1], &self[coord2])
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

    func hasText(at coordinate: Coordinate) -> Bool {
        return self[coordinate] != nil
    }

    mutating func removeTexts(at coordinates: Set<Coordinate>) {
        for coordinate in coordinates {
            self[coordinate] = nil
        }
    }

    /// Gets the texts at `coordinates`
    /// Ordering of the texts will correspond to the ordering of `coordinates`
    ///
    /// - Parameter coordinates: Array of Coordinate to get the text at
    /// - Returns: Array of String correspond to the texts at `coordinates`
    ///            Returns nil if any of the coordinates is out of bounds or has no text
    func getTexts(at coordinates: [Coordinate]) -> [String]? {
        var texts: [String] = []
        for coordinate in coordinates {

            guard 0..<numRows ~= coordinate.row && 0..<numColumns ~= coordinate.col,
                let text = self[coordinate] else {
                return nil
            }
            texts.append(text)
        }
        return texts
    }

    /// Gets the texts at `coordinates` joined, optionally separated by a separator.
    ///
    /// - Parameter coordinates: array of Coordinates to get the text at
    /// - Parameter separator: separator of the strings, defaults to empty string
    /// - Returns: Concatenated string from texts at `coordinates`
    ///            Returns nil if any of the coordinates is out of bounds or has no text
    func getConcatenatedTexts(at coordinates: [Coordinate], separatedBy separator: String = "") -> String? {
        return getTexts(at: coordinates)?.joined(separator: separator)
    }

    /// Determines whether the given Coordinate is in the bounds of the grid.
    ///
    /// - Parameter coordinate: the coordinate to be determined
    /// - Returns: true if and only if the coordinate is inside the grid
    func isInBounds(coordinate: Coordinate) -> Bool {
        return (0..<numRows ~= coordinate.row) && (0..<numColumns ~= coordinate.col) 
    }
}
