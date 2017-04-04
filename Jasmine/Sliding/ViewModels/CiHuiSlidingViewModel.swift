import Foundation

class CiHuiSlidingViewModel: BaseSlidingViewModel {
    /// Initializes the game
    ///
    /// - Parameters:
    ///   - time: initial time
    ///   - gameData: game data
    ///   - rows: rows in the game
    init(time: TimeInterval, gameData: GameData, rows: Int) {
        let phrases = gameData.phrases.next(count: rows)

        var tiles: [String] = []
        for phrase in phrases {
            let hanzi = phrase.chinese.characters.map { String($0) }
            let pinyin = phrase.pinyin.components(separatedBy: " ")

            tiles += (hanzi + pinyin)
        }
        let tilesExceptLast = tiles.enumerated().map { (idx, tile) in
            (idx == tiles.count - 1) ? nil : tile
        }

        super.init(time: time, gameData: gameData, tiles: tilesExceptLast,
                   rows: rows, columns: Constants.Game.Sliding.columns)

        gameTitle = Constants.Game.Sliding.CiHui.gameTitle
        gameInstruction = Constants.Game.Sliding.CiHui.gameInstruction
    }

    /// Returns if and only if the game is won, that is:
    /// every row/column except the last contains the cihui and the respective pinyin.
    override func lineIsCorrect(_ line: [Coordinate]) -> Bool {
        if line.isAllTrue(predicate: { $0.row == gridData.numRows - 1 }) ||
           line.isAllTrue(predicate: { $0.col == gridData.numColumns - 1 }) {
            return true
        }

        let firstHalfCoordinates = Array(line[0..<(line.count / 2)])
        let secondHalfCoordinates = Array(line[(line.count / 2)..<line.count])

        if let text = gridData.getConcatenatedTexts(at: firstHalfCoordinates),
           let phrase = gameData.phrases.first(whereChinese: text) {
            // First half forms a hanzi phrase
            // TODO: - Magic String
            let pinyin = gridData.getConcatenatedTexts(at: secondHalfCoordinates, separatedBy: " ")
            return phrase.pinyin == pinyin

        } else if let text = gridData.getConcatenatedTexts(at: secondHalfCoordinates),
                  let phrase = gameData.phrases.first(whereChinese: text) {
            // Second half forms a hanzi phrase
            // TODO: - Magic String
            let pinyin = gridData.getConcatenatedTexts(at: firstHalfCoordinates, separatedBy: " ")
            return phrase.pinyin == pinyin

        } else {
            return false
        }
    }
}
