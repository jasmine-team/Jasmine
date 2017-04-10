/// The ViewModel for the level selector part.
protocol LevelSelectorViewModelProtocol {
    /// The defaults levels in the game.
    var defaultLevels: [GameInfo] { get }
    /// The custom levels in the game.
    var customLevels: [GameInfo] { get }

    /// Deletes the custom level
    ///
    /// - Parameter gameInfo: the game info
    func deleteLevel(from gameInfo: GameInfo)
}
