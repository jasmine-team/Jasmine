/// The ViewModel for the level selector part.
protocol LevelSelectorViewModelProtocol {
    /// The defaults levels in the game.
    var defaultLevels: [GameInfo] { get }
    /// The custom levels in the game.
    var customLevels: [GameInfo] { get }

    /// Get all the phrases from the given GameInfo
    ///
    /// - Parameter gameInfo: the game info
    /// - Returns: all phrases in the game info
    func getLevelPhrases(from gameInfo: GameInfo) -> [String]

    /// Deletes the custom level
    ///
    /// - Parameter gameInfo: the game info
    func deleteLevel(from gameInfo: GameInfo)
}
