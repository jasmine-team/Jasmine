import RealmSwift

/// Simple container for information necessary at the end of every game
class LevelResult: Object {

    /// Set time played at moment of creation
    private(set) dynamic var timePlayed: Date = Date()
    private(set) dynamic var score: Int = 0
    private dynamic var rawGameResult: String = ""

    let phrases = List<Phrase>()

    convenience init(gameData: GameData) {
        self.init()
        phrases.append(objectsIn: gameData.phrasesTested)
        score = gameData.score

        switch gameData.gameStatus {
        case .endedWithLost,
             .endedWithWon:
            rawGameResult = gameData.gameStatus.rawValue
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
        return ["gameResult"]
    }

}
