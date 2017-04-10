/// The ViewController delegate for the LevelSelector. ViewModel will own this.
protocol LevelSelectorViewControllerDelegate: class {
    /// Reload the level at the given index.
    ///
    /// - Parameter index: the index for the level to be reloaded
    /// - Parameter isDefault: whether the level is default or not
    func reloadLevel(at index: Int, isDefault: Bool)

    /// Reload all levels.
    func reloadAllLevels()
}
