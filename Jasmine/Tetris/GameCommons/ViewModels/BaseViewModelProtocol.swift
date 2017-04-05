import Foundation

/// Sets the shared functionalities that are applicable across all view model declarations.
/// This protocol will be inherited by all the specialised view model protocols.
protocol BaseViewModelProtocol: class, GameDescriptorProtocol {

    // MARK: Game Operations
    /// Stores the grid data that will be used to display in the view controller.
    var gridData: TextGrid { get }

    /// Tells the view model that the game has started.
    func startGame()
}
