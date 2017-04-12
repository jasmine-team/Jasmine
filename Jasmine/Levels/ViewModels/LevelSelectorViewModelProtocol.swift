/// The ViewModel for the level selector part.
protocol LevelSelectorViewModelProtocol {

    /// The delegate that the using view controller should implement.
    var delegate: LevelSelectorViewControllerDelegate? { get set }

    /// The defaults levels in the game.
    var defaultLevels: [GameInfo] { get }

    /// The custom levels in the game.
    var customLevels: [GameInfo] { get }

    /// Deletes the custom level
    ///
    /// - Parameter row: the row number
    func deleteCustomLevel(fromRow row: Int)

    /// Get the phrase explorer VM from the game info
    ///
    /// - Parameters:
    ///   - row: the row number that is pressed
    ///   - isDefault: whether the level is from the default levels or custom levels
    /// - Returns: the PhraseExplorerVM to be segued into, containing the phrases
    func getPhraseExplorerViewModel(fromRow row: Int, isDefault: Bool) -> PhrasesExplorerViewModel

    /// Play the game
    ///
    /// - Parameters:
    ///   - row: the row number that is pressed
    ///   - isDefault: whether the level is from the default levels or custom levels
    /// - Returns: the VM to be segued into and played
    func playGame(fromRow row: Int, isDefault: Bool) -> BaseViewModelProtocol
}
