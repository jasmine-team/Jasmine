class LevelDesignerViewModel {

    /// The levels data to add to or update. To be set by LevelSelectionViewController
    private let levels: Levels
    /// The level under edit. To be set by LevelSelectionViewController
    private let levelToEdit: Level?
    /// The phrases that has been selected. To be set to PhrasesExplorerViewModel's phrases

    var gameInfo: GameInfo? {
        guard let levelToEdit = levelToEdit else {
            return nil
        }
        return GameInfo(uuid: levelToEdit.uuid, levelName: levelToEdit.name,
                        gameType: levelToEdit.gameType, gameMode: levelToEdit.gameMode)
    }

    let selectedPhrases: Phrases?

    var selectedPhrasesCount: Int {
        return selectedPhrases?.count ?? 0
    }

    init(levels: Levels, levelToEdit: Level? = nil) {
        self.levels = levels
        self.levelToEdit = levelToEdit
        self.selectedPhrases = levelToEdit?.phrases
    }

    /// Saves the level with the given game stats
    ///
    /// - Parameters:
    ///   - name: name of the level, default name will be used if nil
    ///   - gameType: game type of the level
    ///   - gameMode: game mode of the level
    /// - Throws: error if failed to save
    func saveLevel(name: String?, gameType: GameType, gameMode: GameMode) throws {
        if let levelToEdit = levelToEdit {
            try levels.deleteLevel(levelToEdit)
        }
        try levels.addCustomLevel(name: name, gameType: gameType,
                                  gameMode: gameMode, phrases: [])
    }

    // TODO : set phrases for levels call (waiting for Phrases and PhrasesExplorerViewModel update)
    func updateCustomLevel(name: String, gameType: GameType, gameMode: GameMode) throws {
        try levels.updateCustomLevel(name: name, gameType: gameType, gameMode: gameMode, phrases: [])
    }
}
