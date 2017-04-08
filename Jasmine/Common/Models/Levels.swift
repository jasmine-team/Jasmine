import RealmSwift

class Levels {

    private static let difficultyKey = "difficulty"

    weak var realm: Realm!
    weak var delegate: LevelsDelegate?

    private lazy var rawCustomLevels: Results<Level> = self.filterIsReadOnly(bool: false)
    
    private(set) lazy var original: [Level] = Array(self.filterIsReadOnly(bool: true))
    private(set) lazy var custom: [Level] = Array(self.rawCustomLevels)

    init(realm: Realm) {
        self.realm = realm
    }

    @discardableResult
    func addCustomLevel(name: String, gameType: GameType, gameMode: GameMode, phrases: Phrases) -> Bool {
        let level = Level(value: [
            "name": name,
            "rawGameType": gameType,
            "rawGameMode": gameMode,
            "phrases": phrases.toArray()
        ])
        realm.beginWrite()
        realm.add(level)
        // Making sure the change notification doesn't apply the change a second time
        do {
            try realm.commitWrite(withoutNotifying: [token])
            return true
        } catch {
            assertionFailure(error.localizedDescription)
            return false
        }
    }

    func deleteLevel(_ level: Level) {
        if rawCustomLevels.contains(level){
            realm.delete(level)
        }
    }
    
    func resetAll() {
        realm.delete(rawCustomLevels)
    }

    // MARK: Helper functions

    private func filterIsReadOnly(bool: Bool) -> Results<Level> {
        return realm.objects(Level.self)
            .filter("isReadOnly == '\(bool)'")
            .sorted(byKeyPath: Levels.difficultyKey)
    }

    lazy var token: NotificationToken = self.rawCustomLevels.addNotificationBlock { changes in
        switch changes {
        case .initial:
            return
        case .update:
            self.delegate?.levelsDidUpdate()
        case .error(let error):
            assertionFailure("An error occurred: \(error)")
            return
        }
    }

}

protocol LevelsDelegate: class {
    func levelsDidUpdate()
}
