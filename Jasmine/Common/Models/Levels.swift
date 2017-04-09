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

    init(realm: Realm) {
        self.realm = realm
    }

    /// Adds the level with indicated settings
    ///
    /// - Parameters:
    ///   - name: name of level
    ///   - gameType: game type of level
    ///   - gameMode: game mode of level
    ///   - phrases: list of phrases to level
    /// - Throws: Error if cannot add data
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
    }

    /// Deletes the indicated level
    ///
    /// - Parameter level: level to be deleted
    /// - Throws: Error if cannot delete data
    func deleteLevel(_ level: Level) throws {
        if !rawCustomLevels.contains(level) {
            assertionFailure("Cannot delete original levels")
            return
        }
        try realm.write {
            realm.delete(level)
        }
    }

    /// Resets all custom levels
    ///
    /// - Throws: Error if cannot delete data
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
