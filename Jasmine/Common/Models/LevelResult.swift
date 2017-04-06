import RealmSwift

/// Simple container for information necessary at the end of every game
class LevelResult: Object {

    /// Set time played at moment of creation
    private(set) dynamic var timePlayed: Date = Date()
    private dynamic var rawGameResult: String = ""

    let rawPhrases = List<Phrase>()

    convenience init(phrasesUserSeen: Set<Phrase>, result: GameStatus) {
        self.init()
        rawPhrases.append(objectsIn: phrasesUserSeen)

        switch result {
        case .endedWithLost:
            rawGameResult = result.rawValue
        case .endedWithWon:
            rawGameResult = result.rawValue
        default:
            assertionFailure("Game result is not valid")
        }
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
        return ["phrases", "gameResult"]
    }

}
