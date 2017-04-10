/// The ViewModel for the level selector part.
protocol LevelSelectorViewModelProtocol {
    /// The defaults levels in the game.
    var defaultLevels: [GameInfo] { get }
    /// The custom levels in the game.
    var customLevels: [GameInfo] { get }

    /// Get all the phrases from the given level UUID.
    ///
    /// - Parameter levelID: the level UUID
    /// - Returns: all phrases in the level UUID
    func getLevelPhrases(from uuid: String) -> [String]

    /// Deletes the custom level
    ///
    /// - Parameter levelID: the level ID
    func deleteLevel(from uuid: String)
}
