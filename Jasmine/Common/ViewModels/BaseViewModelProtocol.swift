import Foundation

/// Sets the shared functionalities that are applicable across all view model declarations.
/// This protocol will be inherited by all the specialised view model protocols.
protocol BaseViewModelProtocol: GameStatisticsProtocol {
    /// Tells the view model that the game has started.
    func startGame()

    weak var scoreDelegate: ScoreUpdateDelegate? { get }
    weak var timeDelegate: TimeUpdateDelegate? { get }
}
