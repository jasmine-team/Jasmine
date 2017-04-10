import RealmSwift

/// The ViewModel for the level selector part.
class LevelSelectorViewModel: LevelSelectorViewModelProtocol {
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
            // TODO: Get the actual UUIDs
            GameInfo(uuid: "A", levelName: level.name, gameType: level.gameType, gameMode: level.gameMode)
        }
    }
    /// The custom levels in the game.
    var customLevels: [GameInfo] {
        return rawCustomLevels.map { level in
            GameInfo(uuid: "A", levelName: level.name, gameType: level.gameType, gameMode: level.gameMode)
        }
    }

    init() {
        guard let realm = try? Realm() else {
            fatalError("Cannot create Realm")
        }
        levels = Levels(realm: realm)
    }

    /// Deletes the custom level
    ///
    /// - Parameter gameInfo: the game info
    func deleteLevel(from gameInfo: GameInfo) {
        // TODO: Get UUID
        guard let level = rawCustomLevels.first(where: { $0.name == gameInfo.uuid }),
              ((try? levels.deleteLevel(level)) != nil) else {
            assertionFailure("Cannot delete level, somehow")
            return
        }
    }

    /// Get the phrase explorer VM from the game info
    ///
    /// - Parameter gameInfo: the game info to be passed
    func getPhraseExplorerViewModel(from gameInfo: GameInfo) -> PhrasesExplorerViewModel {
        // TODO: Get UUID
        guard let level = rawCustomLevels.first(where: { $0.name == gameInfo.uuid }) else {
            fatalError("Cannot get level, somehow")
        }

        // TODO
        return PhrasesExplorerViewModel(phrases: level.phrases, amount: 3)
    }

    /// Play the game 
    ///
    /// - Parameter gameInfo: the game info to be passed
    func playGame(from gameInfo: GameInfo) -> BaseViewModelProtocol {
        guard let gameManager = try? GameManager() else {
            fatalError("Error with Realm")
        }

        // TODO: Get UUID
        guard let level = rawCustomLevels.first(where: { $0.name == gameInfo.uuid }) else {
            fatalError("Cannot get level, somehow")
        }
        let gameData = gameManager.createGame(fromLevel: level)

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
}
