import RealmSwift

/// The ViewModel for the level selector part.
class LevelSelectorViewModel: LevelSelectorViewModelProtocol {
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
        return rawCustomLevels.map { level in GameInfo.from(level) }
    }

    init() {
        guard let realm = try? Realm() else {
            fatalError("Cannot create Realm")
        }
        self.realm = realm
        levels = Levels(realm: realm)
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
        let level = isDefault ? rawDefaultLevels[row] : rawCustomLevels[row]
        return PhrasesExplorerViewModel(phrases: level.phrases)
    }

    /// Play the game 
    ///
    /// - Parameter gameInfo: the game info to be passed
    func playGame(fromRow row: Int, isDefault: Bool) -> BaseViewModelProtocol {
        let level = isDefault ? rawDefaultLevels[row] : rawCustomLevels[row]
        let gameManager = GameManager(realm: realm)
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
            fallthrough
        case (.tetris, .ciHui):
            return TetrisGameViewModel(gameData: gameData)
        }
    }
}
