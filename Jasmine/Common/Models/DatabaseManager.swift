import RealmSwift

/// A singleton database accessor to get instances of data
class DatabaseManager {

    static let sharedInstance: DatabaseManager {
        do {
            let realm = try Realm()
            return DatabaseManager(realm: realm)
        } catch {
            fatalError(error.localisedDescription)
        }
        return DatabaseManager(realm: )
    }

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

        let fetch = DatabaseManager.getPhrases(realm: realm)
        allPhrases = fetch.all
        allCiHui = fetch.ciHui
        allChengYu = fetch.chengYu

        self.player = player
    }

    private static func getPhrases(realm: Realm) -> (all: Phrases, ciHui: Phrases, chengYu: Phrases) {
        let allPhrasesResult = realm.objects(Phrase.self)
        let ciHui = allPhrasesResult.filter(DatabaseManager.getChinesePredicate(gameType: .ciHui))
        let chengYu = allPhrasesResult.filter(DatabaseManager.getChinesePredicate(gameType: .chengYu))
        return (all: Phrases(allPhrasesResult), ciHui: Phrases(ciHui), chengYu: Phrases(chengYu))
    }

    private static func getChinesePredicate(gameType: GameType) -> String {
        let count = gameType == .ciHui ? 2 : 4
        return "rawChinese LIKE '\(String(repeating: "?", count: count))'"
    }

    private static func getPlayer(realm: Realm) -> Player {
        if let player = realm.objects(Player.self).first {
            return player
        }
        let player = Player()
        try realm.write {
            realm.add(player)
        }
        return player
    }

}
