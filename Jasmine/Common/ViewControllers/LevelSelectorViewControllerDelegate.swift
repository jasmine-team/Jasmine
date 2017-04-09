/// The ViewController delegate for the LevelSelector. ViewModel will own this.
protocol LevelSelectorViewControllerDelegate: class {
    /// Reload the level at the given ID.
    ///
    /// - Parameter levelID: the ID of the level
    func reloadLevel(at levelID: Int)

    /// Reload all levels.
    func reloadAllLevels()
}
