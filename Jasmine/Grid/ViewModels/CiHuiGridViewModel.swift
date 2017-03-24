import Foundation

class CiHuiGridViewModel: BaseGridViewModel {
    init(time: TimeInterval, phrases: [Phrase]) {
        super.init(time: time, answers: phrases)
    }

    var gameTitle = "CiHui Grid Game"
}
