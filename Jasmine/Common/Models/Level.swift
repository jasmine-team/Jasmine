import RealmSwift

/// Simple container for information necessary for every single game
class Level: Object {

    private(set) dynamic var name: String = "Untitled Level"    // TODO: Discuss renaming capability
    private(set) dynamic var timePlayed: Date = Date()  // Set time played at moment of creation

    private(set) dynamic var isReadOnly: Bool = false
    private dynamic var rawGameType: String = ""
    private dynamic var rawGameResult: String = ""

    dynamic var difficulty: Int = -1    // realm doesn't allow values without defaults

    let phrasesTested = List<Phrase>()

    private var phrases: Results<Phrase>! // Set from manager

    /// MARK: non-persisted properties
    
    /// Current progress or result of the level
    var gameResult: GameStatus {
        get {
            guard let gameStatus = GameStatus(rawValue: rawGameResult) else {
                assertionFailure("Game result is not valid")
                return .endedWithWon
            }
            return gameStatus 
        }
        set {
            rawGameResult = newValue.rawValue
        }
    }

    /// Returns the game type of the level, returns ci hui by default if not set
    var gameType: GameType {
        get {
            guard let gameType = GameType(rawValue: rawGameType) else {
                assertionFailure("Game result is not valid")
                return .ciHui
            }
            return gameType 
        }
        set {
            rawGameType = newValue.rawValue
        }
    }
    
    override static func ignoredProperties() -> [String] {
        return ["phrases", "gameType", "gameResult"]
    }
    
}
