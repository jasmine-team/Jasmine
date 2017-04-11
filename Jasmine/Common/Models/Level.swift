import RealmSwift

/// Represents a data for a level, has history of game results, is immutable
class Level: Object {
    
    /// Unique identifier for every level to be differentiated
    dynamic private(set) var uuid: String = UUID().uuidString

    dynamic private(set) var name: String = "Untitled Level"
    // difficulty of the level, higher means more difficult
    // 0 since realm doesn't allow non-default values
    dynamic private(set) var difficulty: Int = 0
    dynamic private(set) var isReadOnly: Bool = false

    private dynamic var rawGameType: String = GameType.ciHui.rawValue
    private dynamic var rawGameMode: String = GameMode.swapping.rawValue

    /// Accessible by other model classes
    let history = LinkingObjects(fromType: LevelResult.self, property: "level")
    private let rawPhrases = List<Phrase>()

    override static func primaryKey() -> String? {
        return "uuid"
    }
    /// MARK: non-persisted properties

    /// GameType of level, returns cihui by default
    var gameType: GameType {
        guard let gameType = GameType(rawValue: rawGameType) else {
            assertionFailure("Game type is invalid")
            return GameType.ciHui
        }
        return gameType
    }

    /// GameMode of the level, returns swapping by default
    var gameMode: GameMode {
        guard let gameMode = GameMode(rawValue: rawGameMode) else {
            assertionFailure("Game mode is invalid")
            return GameMode.swapping
        }
        return gameMode
    }

    /// All phrases for this level
    lazy private(set) var phrases: Phrases = {
        return Phrases(self.rawPhrases)
    }()

    override static func ignoredProperties() -> [String] {
        return ["gameType", "gameMode", "phrases"]
    }

}
