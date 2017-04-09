import RealmSwift

class Levels {

    private static let difficultyKey = "difficulty"

    weak var realm: Realm!
    weak var delegate: LevelsDelegate?

    private lazy var rawCustomLevels: Results<Level> = self.filterIsReadOnly(bool: false)

    var original: [Level] {
        return Array(self.filterIsReadOnly(bool: true))
    }
    var custom: [Level] {
        return Array(self.filterIsReadOnly(bool: false))
    }
//    private(set) lazy var original: [Level] = Array(self.filterIsReadOnly(bool: true))
//    private(set) lazy var custom: [Level] = Array(self.rawCustomLevels)

    init(realm: Realm) {
        self.realm = realm
    }

    func addCustomLevel(name: String, gameType: GameType, gameMode: GameMode, phrases: [Phrase]) throws {
        let level = Level(value: [
            "name": name,
            "rawGameType": gameType.rawValue,
            "rawGameMode": gameMode.rawValue,
            "rawPhrases": phrases
        ])
        try realm.write {
            realm.add(level)
        }
//        realm.beginWrite()
//        realm.add(level)
//        // Making sure the change notification doesn't apply the change a second time
//        try realm.commitWrite(withoutNotifying: [token])
    }

    func deleteLevel(_ level: Level) throws {
        if !rawCustomLevels.contains(level) {
            assertionFailure("Cannot delete original levels")
            return
        }
        try realm.write {
            realm.delete(level)
        }
    }

    func resetAll() throws {
        try realm.write {
            realm.delete(rawCustomLevels)
        }
    }

    // MARK: Helper functions

    private func filterIsReadOnly(bool: Bool) -> Results<Level> {
        return realm.objects(Level.self)
            .filter("isReadOnly == \(bool)")
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
