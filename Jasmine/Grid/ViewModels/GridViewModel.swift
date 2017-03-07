import Foundation

class GridViewModel: GameViewModel {
    private var grid: [IndexPath: Character] = [:]

    /// Returns the grid of the current game
    ///
    /// - Returns: the grid
    public func getGrid() -> [IndexPath: Character] {
        return grid
    }

    /// Populates the grid according to the specified game type.
    ///
    /// - Parameter type: the game type
    public func populateGrid(type: GameType) {
        var characters: [[Character]] = []

        // TODO: Don't hardcore these characters
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
        var allChars = Array(characters.joined())

        // Shuffle allChars
        for originalIndex in 0..<allChars.count {
            // Random number in [i, allChars.count)
            let swapIndex = Int(arc4random_uniform(UInt32(allChars.count - originalIndex))) + originalIndex
            swap(&allChars[originalIndex], &allChars[swapIndex])
        }

        // Place back allChars to the grid
        grid.removeAll()
        var idx = 0
        for row in 0..<rows {
            for item in 0..<cols {
                grid[IndexPath(item: item, section: row)] = allChars[idx]
                idx += 1
            }
        }
    }

    /// Swaps tiles from the first location with the second location.
    ///
    /// - Parameters:
    ///   - firstLocation: first location of the grid to be swapped
    ///   - secondLocation: second location of the grid to be swapped
    public func swapTiles(_ firstLocation: IndexPath, _ secondLocation: IndexPath) {
        swap(&grid[firstLocation], &grid[secondLocation])
    }
}