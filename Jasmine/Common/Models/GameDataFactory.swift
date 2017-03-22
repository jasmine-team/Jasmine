import RealmSwift

/// Responsible for creating game data objects
class GameDataFactory {

    let realm: Realm

    /// Initialize manager with realm instance, useful for testing
    ///
    /// - Parameter realm: realm instance
    init(realm: Realm) {
        self.realm = realm
    }

    /// Initialize manager with default realm instance
    ///
    /// - Throws: realm initialization errors
    convenience init() throws {
        self.init(realm: try Realm())
    }

    /// Creates a game with the indicated difficulty
    ///
    /// - Parameter difficulty: difficulty of the game
    /// - Returns: game data containing relevant phrases
    func createGame(difficulty: Int) -> GameData {
        let gameData = GameData()
        gameData.difficulty = difficulty
        gameData.phrases = realm.objects(Phrase.self)
        return gameData
    }

}
