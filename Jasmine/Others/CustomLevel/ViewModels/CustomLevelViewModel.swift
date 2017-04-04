class CustomLevelViewModel {
    /// The game mode of the level.
    let gameMode: GameMode
    /// The game type of the level.
    let gameType: GameType
    /// The game data of the level.
    let gameData: GameData

    init(gameMode: GameMode, gameType: GameType, gameData: GameData) {
        assert(Constants.Game.possibleCombinations.contains { $0.gameMode == gameMode && $0.gameType == gameType },
               "(GameMode, GameType) pair not available")
        self.gameMode = gameMode
        self.gameType = gameType
        self.gameData = gameData
    }
}
