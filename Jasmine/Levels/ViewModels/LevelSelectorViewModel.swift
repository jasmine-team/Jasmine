import RealmSwift

/// The ViewModel for the level selector part.
class LevelSelectorViewModel: LevelSelectorViewModelProtocol {

    /// The Levels object that manages the level objects
    private let levels: Levels
    /// Default levels as a level array
    private var rawDefaultLevels: [Level] {
        return levels.original
    }
    /// Custom levels as a level array
    private var rawCustomLevels: [Level] {
        return levels.custom
    }

    /// A delegate for the view controller to conform, and the view model to call.
    weak var delegate: LevelSelectorViewControllerDelegate?

    /// The defaults levels in the game.
    var defaultLevels: [GameInfo] {
        return rawDefaultLevels.map { level in
            GameInfo(levelName: level.name, gameType: level.gameType,
                     gameMode: level.gameMode, isEditable: false)
        }
    }

    /// The custom levels in the game.
    var customLevels: [GameInfo] {
        return rawCustomLevels.map { level in GameInfo.from(level: level) }
    }

    init(levels: Levels = Storage.sharedInstance.levels) {
        self.levels = levels
    }

    /// Deletes the custom level
    ///
    /// - Parameter gameInfo: the game info
    func deleteCustomLevel(fromRow row: Int) {
        let level = rawCustomLevels[row]
        guard (try? levels.deleteLevel(level)) != nil else {
            assertionFailure("Cannot delete level")
            return
        }

        delegate?.reloadAllLevels()
    }

    /// Get the phrase explorer VM from the game info
    ///
    /// - Parameter gameInfo: the game info to be passed
    func getPhraseExplorerViewModel(fromRow row: Int, isDefault: Bool) -> PhrasesExplorerViewModel {
        let level = getLevel(isDefault: isDefault, withRow: row)
        return PhrasesExplorerViewModel(phrases: level.phrases)
    }

    /// Get the level designer VM from the game info
    ///
    /// - Parameters:
    ///   - row: the row number that is pressed
    ///   - isDefault: whether the level is from the default levels or custom levels
    ///   - cloneLevel: Whether the level should be cloned or replaced
    /// - Returns: the LevelDesignerVM to be segued into
    func getLevelDesignerViewModel(fromRow row: Int, isDefault: Bool, cloneLevel: Bool) -> LevelDesignerViewModel {
        let level = getLevel(isDefault: isDefault, withRow: row)
        return LevelDesignerViewModel(levels: levels, selectedLevelInfo: (level: level, cloneLevel: cloneLevel))
    }

    /// Get the level designer VM without the game info
    /// - Returns: the LevelDesignerVM to be segued into
    func getLevelDesignerViewModel() -> LevelDesignerViewModel {
        return LevelDesignerViewModel(levels: levels)
    }

    /// Play the game 
    ///
    /// - Parameter gameInfo: the game info to be passed
    func playGame(fromRow row: Int, isDefault: Bool) -> BaseViewModelProtocol {
        let level = getLevel(isDefault: isDefault, withRow: row)
        let gameManager = Storage.sharedInstance.gameManager
        let gameData = gameManager.createGame(fromLevel: level)

        switch (level.gameMode, level.gameType) {
        case (.sliding, .chengYu):
            return ChengYuSlidingViewModel(
                time: GameConstants.Sliding.time, gameData: gameData, rows: GameConstants.Sliding.rows)
        case (.sliding, .ciHui):
            return CiHuiSlidingViewModel(
                time: GameConstants.Sliding.time, gameData: gameData, rows: GameConstants.Sliding.rows)
        case (.swapping, .chengYu):
            return ChengYuSwappingViewModel(
                time: GameConstants.Swapping.time, gameData: gameData, numberOfPhrases: GameConstants.Swapping.rows)
        case (.swapping, .ciHui):
            return CiHuiSwappingViewModel(
                time: GameConstants.Swapping.time, gameData: gameData, numberOfPhrases: GameConstants.Swapping.rows)
        case (.tetris, .chengYu):
            return ChengYuTetrisGameViewModel(gameData: gameData)
        case (.tetris, .ciHui):
            return CiHuiTetrisGameViewModel(gameData: gameData)
        }
    }

    private func getLevel(isDefault: Bool, withRow row: Int) -> Level {
        return isDefault ? rawDefaultLevels[row] : rawCustomLevels[row]
    }
}
