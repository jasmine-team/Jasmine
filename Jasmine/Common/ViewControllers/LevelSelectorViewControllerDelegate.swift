/// The ViewController delegate for the LevelSelector. ViewModel will own this.
protocol LevelSelectorViewControllerDelegate: class {
    /// Reload the default level at the given index.
    ///
    /// - Parameter index: the index for the level to be reloaded
    func reloadDefaultLevel(at index: Int)

    /// Reload the custom level at the given index.
    ///
    /// - Parameter index: the index for the level to be reloaded
    func reloadCustomLevel(at index: Int)

    /// Reload all levels.
    func reloadAllLevels()
}
