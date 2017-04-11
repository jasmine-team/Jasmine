import RealmSwift

class JasmineManager {

    private let realm: Realm

    private let gameManager: GameManager
    private let levels: Levels
    let allPhrases: Phrases

    /// Initialize manager with realm instance, useful for testing
    ///
    /// - Parameter realm: realm instance
    init(realm: Realm) {
        self.realm = realm
        gameManager = GameManager(realm: realm)
        levels = Levels(realm: realm)
        allPhrases = Phrases(List(realm.objects(Phrase.self)))
    }

    /// Initialize manager with default realm instance
    ///
    /// - Throws: realm initialization errors
    convenience init() throws {
        self.init(realm: try Realm())
    }

}
