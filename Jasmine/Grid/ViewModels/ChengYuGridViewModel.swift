import Foundation

class ChengYuGridViewModel: BaseGridViewModel {
    init(time: TimeInterval, phrases: [Phrase]) {
        super.init(time: time, answers: phrases)
    }

    var gameTitle = "ChengYu Grid Game"
}
