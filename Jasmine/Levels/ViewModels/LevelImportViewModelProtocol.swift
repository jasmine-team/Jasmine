protocol LevelImportViewModelProtocol {

    /// The defaults levels in the game.
    var defaultLevels: [GameInfo] { get }

    /// The custom levels in the game.
    var customLevels: [GameInfo] { get }

    /// Get the phrase explorer VM from the game info
    ///
    /// - Parameter gameInfo: the game info to be passed
    func getPhraseExplorerViewModel(from gameInfo: GameInfo) -> PhrasesExplorerViewModel

    /// Toggle whether the level is marked, or not.
    func toggleLevelMarked(for gameInfo: GameInfo) -> Bool

    /// Returns true if the level should be marked, false otherwise.
    func isLevelMarked(for gameInfo: GameInfo) -> Bool
}
