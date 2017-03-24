import Foundation

class GridViewModel: GridViewModelProtocol {
    /// Stores the grid data that will be used to display in the view controller.
    private(set) var gridData: [Coordinate: String] = [:] {
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

    /// Provide a brief title for this game. Note that this title should be able to fit within the
    /// width of the display.
    var gameTitle = "Grid Game"

    /// Provide of a brief description of its objectives and how this game is played.
    /// There is no word count limit, but should be concise.
    var gameInstruction = "Match the Chinese characters with their Pinyins by putting them in one row."

    /// Tells the view model that the game has started.
    func startGame() {
        loadGrid(from: answers)
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

        swapGridData(coord1, and: coord2)

        if hasGameWon {
            gameStatus = .endedWithWon
            currentScore += Int(timeRemaining * Double(Constants.Game.Grid.scoreMultiplierFromTime))
        }

        return true
    }

    /// Returns true iff the game is won
    private var hasGameWon: Bool {
        let sortedGrid = gridData
            .sorted { $0.key < $1.key }
            .map { $0.value }

        // SortedGrid is an array containing all the elements in order.
        // This will iterate through the array and combine them into Constant.Game.Grid.columns elements,
        // then check if the resulting string formed is part of the answers.
        var temporary: [String] = []
        for element in sortedGrid {
            temporary.append(element)
            if temporary.count == Constants.Game.Grid.columns {
                if answers.contains(where: { $0 == temporary }) {
                    temporary = []
                } else {
                    return false
                }
            }
        }
        return true
    }

    /// Loads the grid from an array of array of characters.
    /// The characters will be shuffled before putting it in the grid.
    /// Each element in the main array should have the same length.
    ///
    /// - Parameter characters: the characters to be loaded to the grid
    private func loadGrid(from phrases: [[String]]) {
        let rows = phrases.count
        let cols = phrases.first?.count ?? 0
        assert(rows > 0 && cols > 0, "Number of rows and columns should be more than 0")
        assert(phrases.map { $0.count }.isAllSame, "All rows should have the same length")

        let allChars = phrases.joined().shuffled()

        // Place back allChars to the grid
        gridData.removeAll()
        var idx = 0
        for row in 0..<rows {
            for col in 0..<cols {
                gridData[Coordinate(row: row, col: col)] = allChars[idx]
                idx += 1
            }
        }

        delegate?.redisplayAllTiles()
    }

    /// Swaps two coordinates in the grid data. The built-in swap function cannot be used as
    /// it will introduce concurrent write in gridData's didSet listener.
    ///
    /// - Parameters:
    ///   - coord1: the first coordinate
    ///   - coord2: the second coordinate
    private func swapGridData(_ coord1: Coordinate, and coord2: Coordinate) {
        let initialSecond = gridData[coord2]
        gridData[coord2] = gridData[coord1]
        gridData[coord1] = initialSecond
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
