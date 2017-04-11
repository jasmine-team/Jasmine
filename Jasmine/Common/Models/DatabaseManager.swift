import RealmSwift

/// A singleton database accessor to get instances of data
class DatabaseManager {

    static let sharedInstance: DatabaseManager = {
        do {
            let realm = try Realm()
            return DatabaseManager(realm: realm)
        } catch {
            fatalError(error.localizedDescription)
        }
    }()

    private let realm: Realm
    private let gameManager: GameManager

    /// Levels instance of task
    let levels: Levels

    /// All different locales of phrases
    let allPhrases: Phrases
    let allCiHui: Phrases
    let allChengYu: Phrases

    /// Single player instance, should be created if not existing
    let player: Player

    private init(realm: Realm) {
        self.realm = realm
        gameManager = GameManager(realm: realm)
        levels = Levels(realm: realm)
        
        let allPhrasesResult = realm.objects(Phrase.self)
        allPhrases = Phrases(List(allPhrasesResult))
        allCiHui = DatabaseManager.filter(phrases: allPhrasesResult, ofType: .ciHui)
        allChengYu = DatabaseManager.filter(phrases: allPhrasesResult, ofType: .chengYu)

        self.player = DatabaseManager.getPlayer(realm: realm)
    }

    private static func filter(phrases: Results<Phrase>, ofType gameType: GameType) -> Phrases {
        let count = gameType == .ciHui ? 2 : 4
        let predicate = "rawChinese LIKE '\(String(repeating: "?", count: count))'"
        return Phrases(List(phrases.filter(predicate)))
    }

    private static func getPlayer(realm: Realm) -> Player {
        if let player = realm.objects(Player.self).first {
            return player
        }
        let player = Player()
        do {
            try realm.write {
                realm.add(player)
            }
        } catch {
            print(error.localizedDescription)
        }
        return player
    }

}
