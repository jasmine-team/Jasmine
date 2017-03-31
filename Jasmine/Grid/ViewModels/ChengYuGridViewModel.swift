import Foundation

class ChengYuGridViewModel: BaseGridViewModel {
    init(time: TimeInterval, gameData: GameData, numberOfPhrases: Int) {
        let phrases = gameData.phrases.next(count: numberOfPhrases)

        let answers = phrases.map { $0.chinese.characters.map { char in String(char) } }
        let tiles = answers.flatMap { $0 }

        super.init(time: time, tiles: tiles, possibleAnswers: answers,
                   rows: numberOfPhrases, columns: Constants.Game.Grid.columns)

        gameTitle = "Cheng Yu (成语) Grid Game"
    }
}
