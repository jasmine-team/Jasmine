import RealmSwift

/// A singleton database accessor to get instances of data
class Storage {

    static let sharedInstance: Storage = {
        do {
            let realm = try Realm()
            return Storage(realm: realm)
        } catch {
            fatalError(error.localizedDescription)
        }
    }()

    private let realm: Realm
    let gameManager: GameManager

    /// Levels instance of task
    let levels: Levels

    /// All different locales of phrases
    let allPhrases: Phrases
    let allCiHui: Phrases
    let allChengYu: Phrases

    private init(realm: Realm) {
        self.realm = realm
        gameManager = GameManager(realm: realm)
        levels = Levels(realm: realm)

        let allPhrasesResult = realm.objects(Phrase.self)
        allPhrases = Phrases(List(allPhrasesResult))
        allCiHui = Storage.filter(phrases: allPhrasesResult, ofType: .ciHui)
        allChengYu = Storage.filter(phrases: allPhrasesResult, ofType: .chengYu)
    }

    private static func filter(phrases: Results<Phrase>, ofType gameType: GameType) -> Phrases {
        let count = gameType == .ciHui ? 2 : 4
        let predicate = "rawChinese LIKE '\(String(repeating: "?", count: count))'"
        return Phrases(List(phrases.filter(predicate)))
    }

}
