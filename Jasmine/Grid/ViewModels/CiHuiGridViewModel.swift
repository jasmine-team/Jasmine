import Foundation

class CiHuiGridViewModel: BaseGridViewModel {
    init(time: TimeInterval, gameData: GameData, numberOfPhrases: Int) {
        let phrases = gameData.phrases.next(count: numberOfPhrases)

        var tiles: [String] = []
        for phrase in phrases {
            let hanzi = phrase.chinese.characters.map { String($0) }
            let pinyin = phrase.pinyin.components(separatedBy: " ")

            tiles += (hanzi + pinyin)
        }

        super.init(time: time, gameData: gameData, tiles: tiles,
                   rows: numberOfPhrases, columns: Constants.Game.Grid.columns)

        gameTitle = Constants.Game.Grid.CiHui.gameTitle
        gameInstruction = Constants.Game.Grid.CiHui.gameInstruction
    }

    /// Returns if and only if the game is won, that is: every row contains a valid Cihui and its pinyin.
    override var hasGameWon: Bool {
        for row in 0..<gridData.numRows {
            let firstHalfCoordinates = (0..<(gridData.numColumns / 2))
                .map { Coordinate(row: row, col: $0) }
            let secondHalfCoordinates = ((gridData.numColumns / 2)..<gridData.numColumns)
                .map { Coordinate(row: row, col: $0) }

            if let text = gridData.getConcatenatedTexts(at: firstHalfCoordinates),
               let phrase = gameData.phrases.first(whereChinese: text) {
                // First half forms a hanzi phrase
                // TODO: - Magic String
                let pinyin = gridData.getConcatenatedTexts(at: secondHalfCoordinates, separatedBy: " ")
                if phrase.pinyin != pinyin {
                    return false
                }
            } else if let text = gridData.getConcatenatedTexts(at: secondHalfCoordinates),
                      let phrase = gameData.phrases.first(whereChinese: text) {
                // Second half forms a hanzi phrase
                // TODO: - Magic String
                let pinyin = gridData.getConcatenatedTexts(at: firstHalfCoordinates, separatedBy: " ")
                if phrase.pinyin != pinyin {
                    return false
                }
            } else {
                return false
            }
        }

        return true
    }
}
