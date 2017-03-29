struct CharacterGrid {
    private(set) var grid: [[String?]]

    init(rows: Int, columns: Int) {
        assert(rows > 0 && columns > 0, "Number of rows and columns should be more than 0")

        let oneRow = [String?](repeating: nil, count: columns)
        grid = [[String?]](repeating: oneRow, count: rows)
    }

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

    subscript(row: Int, column: Int) -> String? {
        return grid[row][column]
    }

    subscript(_ coordinate: Coordinate) -> String? {
        return grid[coordinate.row][coordinate.col]
    }

    func horizontallyContainsAll(strings: [[String]]) -> Bool {
        for string in strings {
            if !horizontallyContains(string: string) {
                return false
            }
        }
        return true
    }

    mutating func swap(_ coord1: Coordinate, and coord2: Coordinate) {
        let initialSecond = grid[coord2.row][coord2.col]
        grid[coord2.row][coord2.col] = grid[coord1.row][coord1.col]
        grid[coord1.row][coord1.col] = initialSecond
    }

    private func horizontallyContains(string: [String]) -> Bool {
        return grid.contains { row in
            guard row.count == string.count else {
                return false
            }

            for index in 0..<row.count {
                guard row[index] == string[index] else {
                    return false
                }
            }

            return true
        }
    }
}
