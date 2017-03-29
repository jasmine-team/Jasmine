struct CharacterGrid {
    private(set) var grid: [Coordinate: String]

    init(rows: Int, columns: Int) {

    }

    init(fromArray: [[String]], randomized: Bool) {

    }

    subscript(row: Int, column: Int) -> String {
        return ""
    }

    subscript(_ coordinate: Coordinate) -> String {
        return ""
    }

    func containsHorizontally(_ string: [String]) -> Bool {
        return true
    }
}
