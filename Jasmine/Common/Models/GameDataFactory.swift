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
        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 1, // Set the new schema version.
            // We haven't migrated anything, so oldSchemaVersion = 0.
            // Realm will automatically detect new properties and removed properties
            // by accessing the oldSchemaVersion property.
            migrationBlock: { _, oldSchemaVersion in _ = oldSchemaVersion }
        )
        self.init(realm: try Realm())
    }

    /// Creates game data with the indicated difficulty
    ///
    /// - Parameter difficulty: difficulty of the game
    /// - Returns: game data containing relevant phrases and difficulty
    func createGame(difficulty: Int, type: GameType) -> GameData {
        let phraseLength = lengthOf(type: type)
        let predicate = filterChinese(ofLength: phraseLength)
        let phrases = realm.objects(Phrase.self).filter(predicate)
        let gamePhrases = Phrases(phrases, range: 0..<phrases.count, phraseLength: phraseLength)
        let gameData = GameData(phrases: gamePhrases, difficulty: difficulty)
        return gameData
    }

    /// Creates a predicate that filters based on character count
    ///
    /// - Parameter count: numebr of characters for the chinese phrase
    /// - Returns: a string that follows NSPredicate format
    private func filterChinese(ofLength count: Int) -> String {
        return "rawChinese LIKE '\(String(repeating: "?", count: count))'"
    }

    // Returns the length of phrases for the specified game type
    private func lengthOf(type: GameType) -> Int {
        switch type {
        case .chengYu:
            return 4
        case .ciHui,
             .pinYin:
            return 2
        }
    }

}
