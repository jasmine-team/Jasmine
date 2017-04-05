import Foundation

class ChengYuSlidingViewModel: BaseSlidingViewModel {
    /// Initializes the game
    ///
    /// - Parameters:
    ///   - time: initial time
    ///   - gameData: game data
    ///   - rows: rows in the game
    init(time: TimeInterval, gameData: GameData, rows: Int) {
        let phrases = gameData.phrases.next(count: rows)
        let tiles = phrases.flatMap { $0.chinese.characters.map { char in String(char) } }
        let tilesExceptLast = tiles.enumerated().map { (idx, tile) in
            (idx == tiles.count - 1) ? nil : tile
        }

        super.init(time: time, gameData: gameData, tiles: tilesExceptLast,
                   rows: rows, columns: Constants.Game.Sliding.columns)

        gameTitle = Constants.Game.Sliding.ChengYu.gameTitle
        gameInstruction = Constants.Game.Sliding.ChengYu.gameInstruction
    }

    /// Returns if and only if the game is won, that is: every row is a valid Chengyu.
    override func lineIsCorrect(_ line: [Coordinate]) -> Bool {
        if line.isAllTrue(predicate: { $0.row == gridData.numRows - 1 }) ||
           line.isAllTrue(predicate: { $0.col == gridData.numColumns - 1 }) {
            return true
        }

        guard let text = gridData.getConcatenatedTexts(at: line),
              gameData.phrases.contains(chinese: text) else {
            return false
        }
        return true
    }
}
