import RealmSwift

/// GameData contains relevant statistics and information to play a game
class GameData: Object {

    dynamic var score: Int = 0
    dynamic var difficulty: Int = 0
    var phrases: Results<Phrase>! // Set from manager

    override static func ignoredProperties() -> [String] {
        return ["phrases"]
    }

}
