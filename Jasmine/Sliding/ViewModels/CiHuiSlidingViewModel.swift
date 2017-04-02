import Foundation

class CiHuiSlidingViewModel: BaseSlidingViewModel {
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

        gameTitle = Constants.Game.Sliding.CiHui.gameTitle
        gameInstruction = Constants.Game.Sliding.CiHui.gameInstruction
    }

    /// Returns if and only if the game is won, that is: every row contains a valid Cihui and its pinyin.
    override var hasGameWon: Bool {
        for row in 0..<gridData.numRows {
            let firstHalfCoordinates = (0..<(gridData.numColumns / 2))
                .map { Coordinate(row: row, col: $0) }
            let secondHalfCoordinates = ((gridData.numColumns / 2)..<gridData.numColumns)
                .map { Coordinate(row: row, col: $0) }
            guard let firstText = gridData.getConcatenatedTexts(at: firstHalfCoordinates),
                  let secondText = gridData.getConcatenatedTexts(at: secondHalfCoordinates) else {
                return false
            }

            let firstPhrase = gameData.phrases.first(whereChinese: firstText)
            let secondPhrase = gameData.phrases.first(whereChinese: secondText)

            if firstPhrase?.pinyin != secondText && secondPhrase?.pinyin != firstText {
                return false
            }
        }

        return true
    }
}
