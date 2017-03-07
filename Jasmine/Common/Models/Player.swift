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

    dynamic var flappyPlayCount: Int = 0 {
        didSet {
            incrementTotalPlayCount(from: oldValue, to: flappyPlayCount)
        }
    }
    dynamic var gridPlayCount: Int = 0 {
        didSet {
            incrementTotalPlayCount(from: oldValue, to: gridPlayCount)
        }
    }
    dynamic var tetrisPlayCount: Int = 0 {
        didSet {
            incrementTotalPlayCount(from: oldValue, to: tetrisPlayCount)
        }
    }
}

extension Player {

    fileprivate func incrementTotalScore(from oldValue: Int, to newValue: Int) {
        let difference = newValue - oldValue
        assert(difference >= 0, "Score may only be incremented!")
        totalScore += difference
    }

    fileprivate func incrementTotalPlayCount(from oldValue: Int, to newValue: Int) {
        let difference = newValue - oldValue
        assert(difference >= 0, "Play count may only be incremented!")
        totalPlayCount += difference
    }

}
