import RealmSwift

class LevelImportViewModel: LevelImportViewModelProtocol {
    /// The Realm database of this view mdoel
    private var realm: Realm
    /// The Levels object that manages the level objects
    private var levels: Levels
    /// Default levels as a level array
    private var rawDefaultLevels: [Level] {
        return levels.original
    }
    /// Custom levels as a level array
    private var rawCustomLevels: [Level] {
        return levels.custom
    }
    /// The defaults levels in the game.
    var defaultLevels: [GameInfo] {
        return rawDefaultLevels.map { level in GameInfo.from(level: level) }
    }
    /// The custom levels in the game.
    var customLevels: [GameInfo] {
        return rawCustomLevels.map { level in GameInfo.from(level: level) }
    }
    /// The indices of the default levels that are marked
    private var markedDefaultLevelRows: Set<Int> = []
    /// The indices of the custom levels that are marked
    private var markedCustomLevelRows: Set<Int> = []
    /// Gets a list of levels that are marked.
    var markedLevels: [GameInfo] {
        return markedDefaultLevelRows.map { defaultLevels[$0] } + markedCustomLevelRows.map { customLevels[$0] }
    }

    init(phraseExplorerViewModel: PhrasesExplorerViewModel) {
        guard let realm = try? Realm() else {
            fatalError("Cannot create Realm")
        }
        self.realm = realm
        levels = Levels(realm: realm)
    }

    /// Get the phrase explorer VM from the game info
    ///
    /// - Parameter gameInfo: the game info to be passed
    func getPhraseExplorerViewModel(fromRow row: Int, isDefault: Bool) -> PhrasesExplorerViewModel {
        let level = isDefault ? rawDefaultLevels[row] : rawCustomLevels[row]
        return PhrasesExplorerViewModel(phrases: level.phrases)
    }

    /// Returns true if the level should be marked, false otherwise.
    func isLevelMarked(fromRow row: Int, isDefault: Bool) -> Bool {
        return isDefault ? markedDefaultLevelRows.contains(row) : markedCustomLevelRows.contains(row)
    }

    /// Toggle whether the level is marked, or not.
    func toggleLevelMarked(fromRow row: Int, isDefault: Bool) -> Bool {
        var levels = isDefault ? markedDefaultLevelRows : markedCustomLevelRows
        if levels.contains(row) {
            levels.remove(row)
        } else {
            levels.insert(row)
        }
        return levels.contains(row)
    }
}
