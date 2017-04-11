import RealmSwift

/// The ViewModel for the level selector part.
class LevelSelectorViewModel: LevelSelectorViewModelProtocol {
    /// The Realm database of this view model
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
    func deleteLevel(from gameInfo: GameInfo) {
        let level = getLevel(from: gameInfo.uuid, inArray: rawCustomLevels)
        guard (try? levels.deleteLevel(level)) != nil else {
            assertionFailure("Cannot delete level")
            return
        }
    }

    /// Get the phrase explorer VM from the game info
    ///
    /// - Parameter gameInfo: the game info to be passed
    func getPhraseExplorerViewModel(from gameInfo: GameInfo) -> PhrasesExplorerViewModel {
        let level = getLevel(from: gameInfo.uuid, inArray: rawCustomLevels)
        return PhrasesExplorerViewModel(phrases: level.phrases)
    }

    /// Play the game 
    ///
    /// - Parameter gameInfo: the game info to be passed
    func playGame(from gameInfo: GameInfo) -> BaseViewModelProtocol {
        let gameManager = GameManager(realm: realm)
        let gameData = gameManager.createGame(fromLevel: getLevel(from: gameInfo.uuid,
                                                                  inArray: rawDefaultLevels + rawCustomLevels))

        switch (gameInfo.gameMode, gameInfo.gameType) {
        case (.sliding, .chengYu):
            return ChengYuSlidingViewModel(time: GameConstants.Sliding.time,
                                           gameData: gameData, rows: GameConstants.Sliding.rows)
        case (.sliding, .ciHui):
            return CiHuiSlidingViewModel(time: GameConstants.Sliding.time,
                                         gameData: gameData, rows: GameConstants.Sliding.rows)
        case (.swapping, .chengYu):
            return ChengYuSwappingViewModel(time: GameConstants.Swapping.time,
                                            gameData: gameData, numberOfPhrases: GameConstants.Swapping.rows)
        case (.swapping, .ciHui):
            return CiHuiSwappingViewModel(time: GameConstants.Swapping.time,
                                          gameData: gameData, numberOfPhrases: GameConstants.Swapping.rows)
        case (.tetris, .chengYu):
            return TetrisGameViewModel(gameData: gameData)
        default:
            fatalError("Game mode & game type combination not found")
        }
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
