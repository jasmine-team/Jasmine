protocol LevelImportViewModelProtocol {

    /// The defaults levels in the game.
    var defaultLevels: [GameInfo] { get }

    /// The custom levels in the game.
    var customLevels: [GameInfo] { get }

    /// Gets a list of levels that are marked.
    var markedLevels: [GameInfo] { get }

    /// Get the phrase explorer VM from the game info
    ///
    /// - Parameters:
    ///   - row: the row number that is pressed
    ///   - isDefault: whether the level is from the default levels or custom levels
    /// - Returns: the PhraseExplorerVM to be segued into, containing the phrases
    func getPhraseExplorerViewModel(fromRow row: Int, isDefault: Bool) -> PhrasesExplorerViewModel

    /// Toggle whether the level is marked, or not.
    func toggleLevelMarked(fromRow row: Int, isDefault: Bool) -> Bool

    /// Returns true if the level should be marked, false otherwise.
    func isLevelMarked(fromRow row: Int, isDefault: Bool) -> Bool
}
