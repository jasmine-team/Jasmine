import Foundation
import RealmSwift

/// Player model to store and keep track of user's progress
class Player: Object {

    // MARK: - Score
    dynamic fileprivate(set) var totalScore: Int = 0

    dynamic var flappyScore: Int = 0 {
        didSet {
            incrementTotalScore(from: oldValue, to: flappyScore)
        }
    }
    dynamic var gridScore: Int = 0 {
        didSet {
            incrementTotalScore(from: oldValue, to: gridScore)
        }
    }
    dynamic var tetrisScore: Int = 0 {
        didSet {
            incrementTotalScore(from: oldValue, to: tetrisScore)
        }
    }

    // MARK: - Playcount
    dynamic fileprivate(set) var totalPlayCount: Int = 0

    dynamic fileprivate(set) var flappyPlayCount: Int = 0
    dynamic fileprivate(set) var gridPlayCount: Int = 0
    dynamic fileprivate(set) var tetrisPlayCount: Int = 0
}

extension Player {

    fileprivate func incrementTotalScore(from oldValue: Int, to newValue: Int) {
        let difference = newValue - oldValue
        assert(difference >= 0, "Score may only be incremented!")
        totalScore += difference
    }

    fileprivate func incrementPlayCount(variable: inout Int) {
        variable += 1
        totalPlayCount += 1
    }

    func incrementFlappyPlayCount() {
        incrementPlayCount(variable: &flappyPlayCount)
    }

    func incrementGridPlayCount() {
        incrementPlayCount(variable: &gridPlayCount)
    }

    func incrementTetrisPlayCount() {
        incrementPlayCount(variable: &tetrisPlayCount)
    }

}
