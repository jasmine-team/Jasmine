import RealmSwift

/// Responsible for creating game data objects and saving results
class GameManager {

    private let realm: Realm
    private var currentLevel: Level?

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

    /// Creates game data with the indicated difficulty
    ///
    /// - Parameter difficulty: difficulty of the game
    /// - Returns: game data containing relevant phrases and difficulty
    func createGame(fromLevel level: Level) -> GameData {
        assert(currentLevel == nil, "A game is still ongoing, have you saved the game?")
        let gamePhrases = Phrases(level.phrases, isShuffled: true)
        let gameData = GameData(name: level.name,
                                phrases: gamePhrases,
                                difficulty: level.difficulty)
        return gameData
    }

    func saveGame(result: GameData) {
        guard let currentLevel = currentLevel else {
            assertionFailure("No game ongoing, failed to save")
            return
        }
        let finalResult = LevelResult(gameData: result) // convert game data to LevelResult
        do {
            try currentLevel.addResult(finalResult)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    /// MARK: Helper functions

    /// Creates a predicate that filters based on character count
    ///
    /// - Parameter count: numebr of characters for the chinese phrase
    /// - Returns: a string that follows NSPredicate format
    private func filterChinesePredicate(ofLength count: Int) -> String {
        return "rawChinese LIKE '\(String(repeating: "?", count: count))'"
    }

    // Returns the length of phrases for the specified game type
    private func lengthOf(type: GameType) -> Int {
        switch type {
        case .chengYu:
            return 4
        case .ciHui:
            return 2
        }
    }

}
