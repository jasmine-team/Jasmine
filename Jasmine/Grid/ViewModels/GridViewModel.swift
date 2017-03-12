import Foundation

class GridViewModel: GameViewModel, GridViewModelProtocol {
    /// The grid of the current game.
    private(set) var grid: [IndexPath: Character] = [:]
    /// Remaining time, in seconds.
    private(set) var time: TimeInterval

    /// Creates an instance of the game.
    ///
    /// - Parameters:
    ///   - type: the type of the game
    ///   - time: initial time, in seconds
    required init(type: GameType, time: TimeInterval) {
        self.time = time
        super.init()
        populateGrid(type: type)
    }

    /// Swaps two tiles in the grid.
    internal func swapTile(at first: IndexPath, with second: IndexPath) {
        swap(&grid[first], &grid[second])
    }

    /// Populates the grid according to the specified game type.
    ///
    /// - Parameter type: the game type
    private func populateGrid(type: GameType) {
        var characters: [[Character]] = []

        // TODO: Don't hardcode these characters
        switch type {
        case .chengyu:
            characters = [["我", "们", "爱", "你"], ["我", "们", "爱", "你"],
                          ["我", "们", "爱", "你"], ["我", "们", "爱", "你"]]
        case .pinyin:
            characters = [["w", "m", "我", "们"], ["m", "f", "免", "费"],
                          ["n", "r", "牛", "肉"], ["f", "y", "法", "语"]]
        default:
            break
        }

        loadGrid(from: characters)
    }

    /// Loads the grid from an array of array of characters.
    /// The characters will be shuffled before putting it in the grid.
    /// Each element in the main array should have the same length.
    ///
    /// - Parameter characters: the characters to be loaded to the grid
    private func loadGrid(from characters: [[Character]]) {
        let rows = characters.count
        let cols = characters.first?.count ?? 0
        assert(rows > 0 && cols > 0, "Number of rows and columns should be more than 0")
        assert(Set(characters.map { $0.count }).count == 1, "All rows should have the same length")

        let allChars = characters.joined().shuffled()

        // Place back allChars to the grid
        grid.removeAll()
        var idx = 0
        for (row, col) in zip(0..<rows, 0..<cols) {
            grid[IndexPath(item: col, section: row)] = allChars[idx]
            idx += 1
        }
    }
}
