import Foundation

class CiHuiGridViewModel: BaseGridViewModel {
    init(time: TimeInterval, gameData: GameData) {
        let phrases = gameData.phrases.prefix(4)

        var answers: [[String]] = []
        for phrase in phrases {
            let hanzi = phrase.chinese.characters.map { String($0) }
            let pinyin = phrase.pinyin.components(separatedBy: " ")
            answers.append(hanzi + pinyin)
        }

        super.init(time: time, answers: answers)

        gameTitle = "Ci Hui (词汇) Grid Game"
    }
}
