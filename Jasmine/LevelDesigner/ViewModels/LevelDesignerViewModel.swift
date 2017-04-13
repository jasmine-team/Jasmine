class LevelDesignerViewModel {

    /// The levels data to add to or update. To be set by LevelSelectionViewController
    private let levels: Levels
    /// The level under edit. To be set by LevelSelectionViewController
    private let levelInEdit: Level?

    /// Returns a GameInfo object representing the levelInEdit data to display on VC
    var levelInEditInfo: GameInfo? {
        guard let levelInEdit = levelInEdit else {
            return nil
        }
        return GameInfo.from(level: levelInEdit)
    }

    /// Stores the phrases for each game type,
    /// so that selected phrases are not lost when the user switches game type 
    var selectedPhrases: [GameType: Set<Phrase>] = [:]

    init(levels: Levels, levelToEdit: Level? = nil) {
        self.levels = levels
        self.levelInEdit = levelToEdit
        if let levelToEdit = levelToEdit {
            self.selectedPhrases[levelToEdit.gameType] = Set(levelToEdit.phrases)
        }
    }

    /// Gets the count of the selected phrases for the given game type, for displaying on VC
    ///
    /// - Parameter gameType: the game type for the selected phrases
    /// - Returns: the count of the selected phrases for the given game type
    func getSelectedPhrasesCount(gameType: GameType) -> Int {
        return selectedPhrases[gameType]?.count ?? 0
    }

    /// Saves the level with the given game stats
    ///
    /// - Parameters:
    ///   - name: name of the level, default name will be used if nil
    ///   - gameType: game type of the level
    ///   - gameMode: game mode of the level
    /// - Throws: error if failed to save
    func saveLevel(name: String?, gameType: GameType, gameMode: GameMode) throws {
        if let levelInEdit = levelInEdit {
            try levels.deleteLevel(levelInEdit)
        }
        try levels.addCustomLevel(name: name, gameType: gameType, gameMode: gameMode,
                                  phrases: selectedPhrases[gameType] ?? [])
    }

    func updateCustomLevel(name: String, gameType: GameType, gameMode: GameMode) throws {
        try levels.updateCustomLevel(name: name, gameType: gameType, gameMode: gameMode,
                                     phrases: selectedPhrases[gameType] ?? [])
    }
}
