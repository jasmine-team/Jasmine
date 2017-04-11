struct GameInfo {
    let uuid: String
    let levelName: String
    let gameType: GameType
    let gameMode: GameMode

    static func constructGameInfo(from level: Level) -> GameInfo {
        return GameInfo(uuid: level.uuid,
                        levelName: level.name,
                        gameType: level.gameType,
                        gameMode: level.gameMode)
    }
}

extension GameInfo: Equatable {
    static func == (lhs: GameInfo, rhs: GameInfo) -> Bool {
        return lhs.uuid == rhs.uuid && lhs.levelName == rhs.levelName &&
            lhs.gameType == rhs.gameType && lhs.gameMode == rhs.gameMode
    }
}
