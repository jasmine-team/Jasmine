import Foundation

protocol FlappyGameViewModelProtocol: BaseGameEngineProtocol {

    var delegate: FlappyGameViewControllerDelegate? { get set }

}
