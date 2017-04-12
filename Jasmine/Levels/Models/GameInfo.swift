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
}
