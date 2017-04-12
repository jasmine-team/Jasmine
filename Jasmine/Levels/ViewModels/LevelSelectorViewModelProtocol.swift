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
    /// - Parameter gameInfo: the game info
    func deleteLevel(from gameInfo: GameInfo)

    /// Get the phrase explorer VM from the game info
    ///
    /// - Parameter gameInfo: the game info to be passed
    func getPhraseExplorerViewModel(from gameInfo: GameInfo) -> PhrasesExplorerViewModel

    /// Play the game 
    ///
    /// - Parameter gameInfo: the game info to be passed
    func playGame(from gameInfo: GameInfo) -> BaseViewModelProtocol
}
