import RealmSwift

/// Simple container for information necessary at the end of every game
class LevelResult: Object {

    private static let rawLostInt = 0
    private static let rawWonInt = 1

    /// Set time played at moment of creation
    private(set) dynamic var timePlayed: Date = Date()
    private dynamic var rawGameResult: Int = -1

    let rawPhrases = List<Phrase>()

    convenience init(phrasesUserSeen: Set<Phrase>, result: GameStatus) {
        self.init()
        rawPhrases.append(objectsIn: phrasesUserSeen)

        switch result {
        case .endedWithLost:
            rawGameResult = LevelResult.rawLostInt
        case .endedWithWon:
            rawGameResult = LevelResult.rawWonInt
        default:
            assertionFailure("Game result is not valid")
        }
    }

    /// MARK: non-persisted properties
    var gameResult: GameStatus {
        switch rawGameResult {
        case LevelResult.rawWonInt:
            return .endedWithLost
        case LevelResult.rawWonInt:
            return .endedWithWon
        default:
            assertionFailure("Game result is not set")
            return .endedWithWon
        }
    }

    override static func ignoredProperties() -> [String] {
        return ["phrases", "gameResult"]
    }

}
