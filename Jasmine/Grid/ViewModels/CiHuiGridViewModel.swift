import Foundation

class CiHuiGridViewModel: BaseGridViewModel {
    init(time: TimeInterval, gameData: GameData, numberOfPhrases: Int) {
        let phrases = gameData.phrases.prefix(numberOfPhrases)

        var tiles: [String] = []
        var answers: [[String]] = []
        for phrase in phrases {
            let hanzi = phrase.chinese.characters.map { String($0) }
            let pinyin = phrase.pinyin.components(separatedBy: " ")

            tiles += (hanzi + pinyin)
            answers.append(hanzi + pinyin)
            answers.append(pinyin + hanzi)
        }

        super.init(time: time, tiles: tiles, possibleAnswers: answers,
                   rows: numberOfPhrases, columns: Constants.Game.Grid.columns)

        gameTitle = "Ci Hui (词汇) Grid Game"
    }
}
