import Foundation

class GridViewModel: GridViewModelProtocol {
    /// Stores the grid data that will be used to display in the view controller.
    private(set) var gridData: CharacterGrid {
        didSet {
            delegate?.updateGridData()
        }
    }
    /// Answers for this game. The game is won if this is done
    private var answers: [[String]] = [["1", "2", "3", "4"], ["5", "6", "7", "8"],
                                       ["9", "10", "11", "12"], ["13", "14", "15", "16"]]
    /// The delegate that the View Controller will conform to in some way, so that the Game Engine
    /// View Model can call.
    weak var delegate: GridGameViewControllerDelegate?
    /// Specifies the current score of the game. If the game has not started, it will be the initial
    /// displayed score.
    private(set) var currentScore: Int = 0 {
        didSet {
            delegate?.redisplay(newScore: currentScore)
        }
    }
    /// The timer of this game.
    private(set) var timer = CountDownTimer(totalTimeAllowed: Constants.Game.Grid.time)
    /// The status of the current game.
    private(set) var gameStatus: GameStatus = .notStarted {
        didSet {
            delegate?.notifyGameStatusUpdated()

            if gameStatus != .inProgress {
                timer.stopTimer()
            }
        }
    }

    init() {
        gridData = CharacterGrid(fromInitialGrid: answers, randomized: true)
    }

    /// Provide a brief title for this game. Note that this title should be able to fit within the
    /// width of the display.
    var gameTitle = "Grid Game"

    /// Provide of a brief description of its objectives and how this game is played.
    /// There is no word count limit, but should be concise.
    var gameInstruction = "Match the Chinese characters with their Pinyins by putting them in one row."

    /// Tells the view model that the game has started.
    func startGame() {
        timer = createTimer()
        timer.startTimer(timerInterval: Constants.Game.Grid.timerInterval)
    }

    /// Tells the Game Engine View Model that the user from the View Controller attempts to swap
    /// the specified two tiles.
    ///
    /// Note that if the tiles are swapped, `delegate.updateTiles(...)` should be called to update
    /// the grid data of the cell stored in the view controller. However, there is no need to call
    /// `delegate.redisplayTiles(...)` as it will be done implicitly by the view controller when
    /// the swapping is successful (determined by the returned value).
    ///
    /// - Parameters:
    ///   - coord1: One of the cells to be swapped.
    ///   - coord2: The other cell to be swapped.
    /// - Returns: Returns true if the two coordinates has be swapped, false otherwise.
    func swapTiles(_ coord1: Coordinate, and coord2: Coordinate) -> Bool {
        guard gridData[coord1] != nil && gridData[coord2] != nil else {
            return false
        }

        gridData.swap(coord1, and: coord2)

        if gridData.horizontallyContainsAll(strings: answers) {
            gameStatus = .endedWithWon
            currentScore += Int(timeRemaining * Double(Constants.Game.Grid.scoreMultiplierFromTime))
        }

        return true
    }

    /// The countdown timer for use in this viewmodel.
    ///
    /// - Returns: the countdown timer
    private func createTimer() -> CountDownTimer {
        let timer = CountDownTimer(totalTimeAllowed: totalTimeAllowed)
        timer.timerListener = { status in
            switch status {
            case .start:
                self.gameStatus = .inProgress
                self.delegate?.redisplay(timeRemaining: self.timeRemaining, outOf: self.totalTimeAllowed)
            case .tick:
                self.delegate?.redisplay(timeRemaining: self.timeRemaining, outOf: self.totalTimeAllowed)
            case .finish:
                self.gameStatus = .endedWithLost
            default:
                break
            }
        }

        return timer
    }
}
