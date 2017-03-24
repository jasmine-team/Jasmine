import Foundation

/// Implement this class to describe how a game can be played with a Flappy Game Board.
///
/// Note the convention that the top most target is index 0.
protocol FlappyViewModelProtocol: BaseViewModelProtocol {

    // MARK: Properties
    /// The delegate that the View Controller will conform to in some way, so that the Game Engine
    /// View Model can call.
    var delegate: FlappyViewControllerDelegate? { get set }

    // MARK: Game Operations
    /// Requests a new question from the View Model.
    ///
    /// - Returns: A tuple consisting of the question title, words to be displayed on the projectile
    ///   and a list of words to be displayed on the targets, where index 0 is the top-most target.
    func getNextQuestion() -> FlappyQuestion

    /// Tells the view model that the projectile has landed into one of the targets.
    ///
    /// - Returns: The index of the target where index 0 is the top-most target. This should match
    ///   with the index provided by `getNextQuestion()`.
    func landProjectile(in targetIndex: Int)

    /// Tells the view model that the projectile has failed to land.
    func projectileFailedToLand()
}
