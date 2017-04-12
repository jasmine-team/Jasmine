@testable import Jasmine

extension GameInfo: Equatable {
    public static func == (lhs: GameInfo, rhs: GameInfo) -> Bool {
        return lhs.gameMode == rhs.gameMode && lhs.gameType == rhs.gameType &&
            lhs.isEditable == rhs.isEditable && lhs.levelName == rhs.levelName
    }
}
