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

    /// The default levels that are marked
    private var markedDefaultLevelRows: Set<Level> = []
    /// The custom levels that are marked
    private var markedCustomLevelRows: Set<Level> = []
    /// Gets a list of levels that are marked.
    var markedLevels: [GameInfo] {
        return markedDefaultLevelRows.union(markedCustomLevelRows).map { GameInfo.from(level: $0) }
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
        return isDefault ? markedDefaultLevelRows.contains { $0 == rawDefaultLevels[row] }
                         : markedCustomLevelRows.contains { $0 == rawCustomLevels[row] }
    }

    /// Toggle whether the level is marked, or not.
    func toggleLevelMarked(fromRow row: Int, isDefault: Bool) -> Bool {
        let level = isDefault ? rawDefaultLevels[row] : rawCustomLevels[row]
        var levels = isDefault ? markedDefaultLevelRows : markedCustomLevelRows
        if levels.contains(level) {
            levels.remove(level)
            return false
        } else {
            levels.insert(level)
            return true
        }
    }
}
