class LevelDesignerViewModel {

    /// The levels data to add to or update
    private let levels: Levels
    /// The level under edit and whether it should be cloned
    private let levelInEdit: (level: Level, cloneLevel: Bool)?

    /// Returns a GameInfo object representing the levelInEdit data to display on VC
    var levelInEditInfo: GameInfo? {
        guard let levelInEdit = levelInEdit else {
            return nil
        }
        return GameInfo.from(level: levelInEdit.level)
    }

    /// Stores the phrases for each game type,
    /// so that selected phrases are not lost when the user switches game type 
    var selectedPhrases: [GameType: Set<Phrase>] = [:]

    /// Initialize the VM with levels and optionally info for a selected level.
    /// An optional tuple is chosen over overloading 
    /// as it allows `selectedLevel` and `cloneLevel` to be `let` constants
    ///
    /// - Parameters:
    ///   - levels: levels model to manage the stored levels
    ///   - selectedLevelInfo: a tuple containing the selected level 
    ///                        and whether the level should be cloned or replaced on save.
    init(levels: Levels, selectedLevelInfo: (level: Level, cloneLevel: Bool)? = nil) {
        self.levels = levels
        levelInEdit = selectedLevelInfo
        if let levelInEdit = levelInEdit {
            selectedPhrases[levelInEdit.level.gameType] = Set(levelInEdit.level.phrases)
        }
    }

    /// Gets the count of the selected phrases for the given game type, for displaying on VC
    ///
    /// - Parameter gameType: the game type for the selected phrases
    /// - Returns: the count of the selected phrases for the given game type
    func getSelectedPhrasesCount(gameType: GameType) -> Int {
        return selectedPhrases[gameType]?.count ?? 0
    }

    /// Adds all the phrases in levels associated with `levelInfos` to the selected phrases. 
    ///
    /// - Parameter levelInfos: Levels to import the phrases from
    /// - Precondition: Levels must be of the same game type
    func addToSelectedPhrases(from levelInfos: [GameInfo]) {
        guard let gameType = levelInfos.first?.gameType else {
            return
        }
        assert(levelInfos.map { $0.gameType }.isAllSame, "Selected levels do not have the same game type")
        // Can't use formUnion on dict directly as it might be nil
        selectedPhrases[gameType] = levels.getPhrasesFromLevels(names: levelInfos.map { $0.levelName })
                                          .union(selectedPhrases[gameType] ?? [])
    }

    /// Saves the level with the given game stats
    ///
    /// - Parameters:
    ///   - name: name of the level, default name will be used if nil
    ///   - gameType: game type of the level
    ///   - gameMode: game mode of the level
    /// - Throws: error if failed to save
    func saveLevel(name: String?, gameType: GameType, gameMode: GameMode) throws {
        if let levelInEdit = levelInEdit,
           !levelInEdit.cloneLevel {
            try levels.deleteLevel(levelInEdit.level)
        }
        try levels.addCustomLevel(name: name, gameType: gameType, gameMode: gameMode,
                                  phrases: selectedPhrases[gameType] ?? [])
    }

    func updateCustomLevel(name: String, gameType: GameType, gameMode: GameMode) throws {
        try levels.updateCustomLevel(name: name, gameType: gameType, gameMode: gameMode,
                                     phrases: selectedPhrases[gameType] ?? [])
    }
}
