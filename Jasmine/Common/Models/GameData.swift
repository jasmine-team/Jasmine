import RealmSwift

/// GameData contains relevant statistics and information to play a game
class GameData: Object {

    dynamic var score: Int = 0
    dynamic var difficulty: Int = 0

    lazy var phrases: Results<Phrase> = {
        do {
            let realm = try Realm()
            return realm.objects(Phrase.self)
        } catch {
            fatalError("realm could not be instantiated")
        }
    }()

    override static func ignoredProperties() -> [String] {
        return ["phrases"]
    }

}
