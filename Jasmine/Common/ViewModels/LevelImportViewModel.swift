import RealmSwift

class LevelImportViewModel {
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
        return rawDefaultLevels.map { level in
            GameInfo(uuid: level.uuid, levelName: level.name, gameType: level.gameType, gameMode: level.gameMode)
        }
    }
    /// The custom levels in the game.
    var customLevels: [GameInfo] {
        return rawCustomLevels.map { level in
            GameInfo(uuid: level.uuid, levelName: level.name, gameType: level.gameType, gameMode: level.gameMode)
        }
    }

    /// The previous view model (phrases explorer) before this view model.
    let previousViewModel: PhrasesExplorerViewModel

    init(phraseExplorerViewModel: PhrasesExplorerViewModel) {
        guard let realm = try? Realm() else {
            fatalError("Cannot create Realm")
        }
        self.realm = realm
        levels = Levels(realm: realm)

        previousViewModel = phraseExplorerViewModel
    }

    /// Get the phrase explorer VM from the game info
    ///
    /// - Parameter gameInfo: the game info to be passed
    func getPhraseExplorerViewModel(from gameInfo: GameInfo) -> PhrasesExplorerViewModel {
        let level = getLevel(from: gameInfo.uuid, inArray: rawCustomLevels)
        return PhrasesExplorerViewModel(phrases: level.phrases)
    }

    /// Import phrases from a given level.
    ///
    /// - Parameter level: the level selected
    /// - Returns: the new phrases explorer VM that has phrases inside imported
    func importPhrases(from level: Level) -> PhrasesExplorerViewModel {
        let phrases = level.phrases
        previousViewModel.importPhrases(with: phrases)
        return previousViewModel
    }

    /// Get a level from the given UUID
    ///
    /// - Parameter uuid: the UUID to be searched
    /// - Returns: the level from the UUID
    private func getLevel(from uuid: String, inArray array: [Level]) -> Level {
        guard let level = array.first(where: { $0.uuid == uuid }) else {
            fatalError("Level does not exist")
        }
        return level
    }
}
