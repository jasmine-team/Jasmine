import Foundation

protocol FlappyGameViewModelProtocol: BaseGameViewModelProtocol {

    var delegate: FlappyGameViewControllerDelegate? { get set }

}
