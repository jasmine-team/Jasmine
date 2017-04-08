import RealmSwift

/// Simple container for information necessary at the end of every game
class LevelResult: Object {

    /// Set time played at moment of creation
    private(set) dynamic var timePlayed: Date = Date()
    private(set) dynamic var score: Int = 0
    private dynamic var rawGameResult: String = ""

    let phrases = List<Phrase>()

    convenience init(phrasesUserSeen: Set<Phrase>, result: GameStatus, score: Int) {
        self.init()
        phrases.append(objectsIn: phrasesUserSeen)
        self.score = score

        switch result {
        case .endedWithLost,
             .endedWithWon:
            rawGameResult = result.rawValue
        default:
            assertionFailure("Game result is not valid")
        }
    }

    override static func primaryKey() -> String? {
        return "timePlayed"
    }

    /// MARK: non-persisted properties
    var gameResult: GameStatus {
        guard let gameStatus = GameStatus(rawValue: rawGameResult) else {
            assertionFailure("Game result is not valid")
            return .endedWithWon
        }
        return gameStatus
    }

    override static func ignoredProperties() -> [String] {
        return ["gameResult"]
    }

}
