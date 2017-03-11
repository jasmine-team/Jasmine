import RealmSwift

/// GameData contains relevant statistics and information to play a game
class GameData: Object {

    dynamic var score: Int = 0
    dynamic var difficulty: Int = 0
    var phrases: Results<Phrase>!

    convenience init(instance: Realm) {
        self.init()
        self.phrases = instance.objects(Phrase.self)
    }

    override static func ignoredProperties() -> [String] {
        return ["phrases"]
    }

}
