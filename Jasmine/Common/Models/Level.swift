import RealmSwift

class Level: Object {

    dynamic var name: String = "Untitled Level"
    // difficulty of the level, higher means more difficult
    // 0 since realm doesn't allow non-default values
    dynamic var difficulty: Int = 0

    private dynamic var rawGameType: String = GameType.ciHui.rawValue
    private dynamic var rawGameMode: String = GameMode.swapping.rawValue

    let history = List<LevelResult>()

    override static func primaryKey() -> String? {
        return "name"
    }

    /// MARK: non-persisted properties

    /// GameType of level, returns cihui by default
    var gameType: GameType {
        get {
            guard let gameType = GameType(rawValue: rawGameType) else {
                assertionFailure("Game type is invalid")
                return GameType.ciHui
            }
            return gameType
        }
        set {
            rawGameType = newValue.rawValue
        }
    }

    /// GameMode of the level, returns swapping by default
    var gameMode: GameMode {
        get {
            guard let gameMode = GameMode(rawValue: rawGameType) else {
                assertionFailure("Game mode is invalid")
                return GameMode.swapping
            }
            return gameMode
        }
        set {
            rawGameMode = newValue.rawValue
        }
    }

    override static func ignoredProperties() -> [String] {
        return ["gameType", "gameMode", "phrases"]
    }

}
