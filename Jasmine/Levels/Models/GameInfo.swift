import Foundation

struct GameInfo {

    /// The level name of this level game.
    let levelName: String

    /// The type (chengyu, cihui) of this level game.
    let gameType: GameType

    /// The playing mode (tetris, sliding, swapping) of this level game.
    let gameMode: GameMode

    /// Returns true if this level game is editable.
    let isEditable: Bool

    /// Gets the game info from a given level
    ///
    /// - Parameter level: the level in question
    /// - Returns: a game info as a representation of the level
    static func from(level: Level) -> GameInfo {
        return GameInfo(levelName: level.name, gameType: level.gameType,
                        gameMode: level.gameMode, isEditable: !level.isReadOnly)
    }
}
