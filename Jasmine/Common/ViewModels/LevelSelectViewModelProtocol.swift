/// The ViewModel for the level selector part.
protocol LevelSelectorViewModelProtocol {
    /// The defaults levels in the game.
    var defaultLevels: [GameInfo] { get }
    /// The custom levels in the game.
    var customLevels: [GameInfo] { get }

    /// Get all the phrases from the given level ID.
    ///
    /// - Parameter levelID: the level ID
    /// - Returns: all phrases in the level ID
    func getLevelPhrases(from levelID: Int) -> [String]

    /// Updates the custom level
    ///
    /// - Parameters:
    ///   - levelID: the ID for the level
    ///   - newName: the new name for the level
    ///   - newGameMode: the game mode for the level
    ///   - newGameType: the game type for the level
    func updateLevelData(from levelID: Int, newName: String, newGameMode: GameMode, newGameType: GameType)

    /// Deletes the custom level
    ///
    /// - Parameter levelID: the level ID
    func deleteLevel(from levelID: Int)
}
