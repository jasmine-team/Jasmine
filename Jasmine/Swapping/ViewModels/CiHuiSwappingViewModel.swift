import Foundation

class CiHuiSwappingViewModel: BaseSwappingViewModel {
    init(time: TimeInterval, gameData: GameData, numberOfPhrases: Int) {
        let phrases = gameData.phrases.next(count: numberOfPhrases)

        var tiles: [String] = []
        for phrase in phrases {
            let hanzi = phrase.chinese.characters.map { String($0) }
            let pinyin = phrase.pinyin.components(separatedBy: " ")

            tiles += (hanzi + pinyin)
        }

        super.init(time: time, gameData: gameData, tiles: tiles,
                   rows: numberOfPhrases, columns: Constants.Game.Swapping.columns)

        gameTitle = Constants.Game.Swapping.CiHui.gameTitle
        gameInstruction = Constants.Game.Swapping.CiHui.gameInstruction
    }

    /// Returns if and only if the game is won, that is:
    /// every row/column contains the cihui and the respective pinyin.
    override func lineIsCorrect(_ line: [Coordinate]) -> Bool {
        let firstHalfCoordinates = Array(line[0..<(line.count / 2)])
        let secondHalfCoordinates = Array(line[(line.count / 2)..<line.count])

        if let text = gridData.getConcatenatedTexts(at: firstHalfCoordinates),
           let phrase = gameData.phrases.first(whereChinese: text) {
            // First half forms a hanzi phrase
            // TODO: Magic String
            let pinyin = gridData.getConcatenatedTexts(at: secondHalfCoordinates, separatedBy: " ")
            return phrase.pinyin == pinyin
        } else if let text = gridData.getConcatenatedTexts(at: secondHalfCoordinates),
                  let phrase = gameData.phrases.first(whereChinese: text) {
            // Second half forms a hanzi phrase
            // TODO: Magic String
            let pinyin = gridData.getConcatenatedTexts(at: firstHalfCoordinates, separatedBy: " ")
            return phrase.pinyin == pinyin
        } else {
            return false
        }
    }
}
