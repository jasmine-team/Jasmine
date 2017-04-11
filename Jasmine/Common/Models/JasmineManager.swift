import RealmSwift

class JasmineManager {

    private let realm: Realm

    private let gameManager: GameManager
    let levels: Levels
    let allPhrases: Phrases
    let allCiHui: Phrases
    let allChengYu: Phrases

    /// Initialize manager with realm instance, useful for testing
    ///
    /// - Parameter realm: realm instance
    init(realm: Realm) {
        self.realm = realm
        gameManager = GameManager(realm: realm)
        levels = Levels(realm: realm)
        let allPhrasesResult = realm.objects(Phrase.self)
        allPhrases = Phrases(List(allPhrasesResult))
        let ciHui = allPhrasesResult.filter(JasmineManager.getChinesePredicate(gameType: .ciHui))
        allCiHui = Phrases(List(ciHui))
        let chengYu = allPhrasesResult.filter(JasmineManager.getChinesePredicate(gameType: .chengYu))
        allChengYu = Phrases(List(chengYu))
    }

    /// Initialize manager with default realm instance
    ///
    /// - Throws: realm initialization errors
    convenience init() throws {
        self.init(realm: try Realm())
    }

    private static func getChinesePredicate(gameType: GameType) -> String {
        let count = gameType == .ciHui ? 2 : 4
        return "rawChinese LIKE '\(String(repeating: "?", count: count))'"
    }

}
