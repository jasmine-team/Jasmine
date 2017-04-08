import RealmSwift

class Levels {

    private static let difficultyKey = "difficulty"

    weak var realm: Realm!

    lazy var original: [Level] = {
        return Array(self.filterIsReadOnly(bool: true))
    }()

    lazy var custom: [Level] = {
        return Array(self.filterIsReadOnly(bool: false))
    }()

    private func filterIsReadOnly(bool: Bool) -> Results<Level> {
        return realm.objects(Level.self)
            .filter("isReadOnly == '\(bool)'")
            .sorted(byKeyPath: Levels.difficultyKey)
    }

    func addCustomLevel(name: String, gameType: GameType, gameMode: GameMode, phrases: Phrases) -> Bool {
        let level = Level(value: [
            "name": name,
            "rawGameType": gameType,
            "rawGameMode": gameMode,
            "phrases": phrases.toArray()
        ])
        do {
            try realm.write {
                realm.add(level)
            }
            return true
        } catch {
            assertionFailure(error.localizedDescription)
            return false
        }
    }

}
