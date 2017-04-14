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

    private static let defaultName = "Untitled Level %d"
    /// Returns the next available default name (append numeric to `defaultName`) to save as
    /// If none is available (used up all integers), returns `defaultName` with 0 appended
    var nextAvailableDefaultName: String {
        for i in 1...Int.max {
            let name = String(format: Levels.defaultName, i)
            if !levelNameExists(name) {
                return name
            }
        }
        return String(format: Levels.defaultName, 0)
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
    /// - Throws: Error if failed to add data or level name already exists
    func addCustomLevel(name: String?, gameType: GameType, gameMode: GameMode, phrases: Set<Phrase>) throws {
        guard !phrases.isEmpty else {
            throw LevelsError.noPhraseSelected
        }

        let name = try getValidName(name)
        guard !levelNameExists(name) else {
            throw LevelsError.duplicateLevelName(name)
        }
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

    /// Returns a valid name with whitespaces trimmed
    ///
    /// - Parameter name: original name
    /// - Returns: name with whitespace trimmed, default if no name passed or trimmed name is empty
    /// - Throws: LevelsError.duplicateLevelName if name already exists
    private func getValidName(_ name: String?) throws -> String {
        var trimmedName = name?.trimmingCharacters(in: .whitespaces)
        trimmedName = (trimmedName?.isEmpty ?? true) ? nil : trimmedName
        let name = trimmedName ?? nextAvailableDefaultName

        guard !levelNameExists(name) else {
            throw LevelsError.duplicateLevelName(name)
        }
        return name
    }

    /// Checks if the level name already exists
    ///
    /// - Parameter name: the level name to check
    /// - Returns: true if the level name already exists
    func levelNameExists(_ name: String) -> Bool {
        return getLevel(name: name) != nil
    }

    /// Gets the level with the given level name
    ///
    /// - Parameter name: the level name to search for
    /// - Returns: the level associated with the name, nil if no such level
    private func getLevel(name: String) -> Level? {
        return custom.first { $0.name == name }
    }

    /// Deletes the level `level` from the custom levels. Do nothing if it's not in custom levels.
    ///
    /// - Parameter level: custom level to be deleted
    /// - Throws: Error if failed to delete data
    func deleteLevel(_ level: Level) throws {
        guard rawCustomLevels.contains(level) else {
            return
        }
        try realm.write {
            realm.delete(level)
        }
    }

    /// Updates the custom level with the name `name`
    ///
    /// - Parameters:
    ///   - name: the name of the custom level to update
    ///   - gameType: the updated game type
    ///   - gameMode: the updated game mode
    ///   - phrases: the updated phrases
    /// - Throws: Error if failed to add data
    func updateCustomLevel(name: String, gameType: GameType, gameMode: GameMode, phrases: Set<Phrase>) throws {
        guard let level = getLevel(name: name) else {
            fatalError("Unable to find level with name \(name)")
        }
        try deleteLevel(level)
        try addCustomLevel(name: name, gameType: gameType, gameMode: gameMode, phrases: phrases)
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
