import RealmSwift

class LevelImportViewModel: LevelImportViewModelProtocol {
    /// The Realm database of this view mdoel
    private var realm: Realm
    /// The Levels object that manages the level objects
    private var levels: Levels
    /// The game type that should be displayed
    private var displayedType: GameType?
    /// Default levels as a level array
    private var rawDefaultLevels: [Level] {
        return levels.original
            .filter { $0.gameType == displayedType }
    }
    /// Custom levels as a level array
    private var rawCustomLevels: [Level] {
        return levels.custom
            .filter { $0.gameType == displayedType }
    }
    /// The defaults levels in the game.
    var defaultLevels: [GameInfo] {
        return rawDefaultLevels
            .map { level in GameInfo.from(level: level) }
    }
    /// The custom levels in the game.
    var customLevels: [GameInfo] {
        return rawCustomLevels
            .map { level in GameInfo.from(level: level) }
    }

    /// The set of marked levels.
    private var markedLevelsSet: Set<Level> = []

    /// THe list of marked levels.
    var markedLevels: [GameInfo] {
        return markedLevelsSet.map { GameInfo.from(level: $0) }
    }

    init(withType type: GameType? = nil) {
        guard let realm = try? Realm() else {
            fatalError("Cannot create Realm")
        }
        self.realm = realm
        levels = Levels(realm: realm)
        displayedType = type
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
        let level = isDefault ? rawDefaultLevels[row] : rawCustomLevels[row]
        return markedLevelsSet.contains(level)
    }

    /// Toggle whether the level is marked, or not.
    func toggleLevelMarked(fromRow row: Int, isDefault: Bool) -> Bool {
        let level = isDefault ? rawDefaultLevels[row] : rawCustomLevels[row]
        if markedLevelsSet.contains(level) {
            markedLevelsSet.remove(level)
            return false
        } else {
            markedLevelsSet.insert(level)
            return true
        }
    }
}
