import Foundation

class CiHuiGridViewModel: BaseGridViewModel {
    /// The game data of this game.
    let gameData: GameData

    init(time: TimeInterval, gameData: GameData, numberOfPhrases: Int) {
        self.gameData = gameData
        let phrases = gameData.phrases.next(count: numberOfPhrases)

        var tiles: [String] = []
        for phrase in phrases {
            let hanzi = phrase.chinese.characters.map { String($0) }
            let pinyin = phrase.pinyin.components(separatedBy: " ")

            tiles += (hanzi + pinyin)
        }

        super.init(time: time, tiles: tiles, rows: numberOfPhrases, columns: Constants.Game.Grid.columns)

        gameTitle = Constants.Game.Grid.CiHui.gameTitle
        gameInstruction = Constants.Game.Grid.CiHui.gameInstruction
    }

    /// Returns if and only if the game is won, that is: every row contains a valid Cihui and its pinyin.
    override var hasGameWon: Bool {
        for row in 0..<gridData.numRows {
            var firstText = ""
            var secondText = ""

            for col in 0...1 {
                guard let tile = gridData[Coordinate(row: row, col: col)] else {
                    return false
                }
                firstText += tile
            }
            for col in 2...3 {
                guard let tile = gridData[Coordinate(row: row, col: col)] else {
                    return false
                }
                secondText += tile
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