import Foundation

class GridViewModel: GridViewModelProtocol {
    /// Stores the grid data that will be used to display in the view controller.
    private(set) var gridData: [Coordinate: String] = [:]
    /// Answers for this game. The game is won if this is done
    private var answers: [[String]] = [["1", "2", "3", "4"], ["5", "6", "7", "8"],
                                       ["9", "10", "11", "12"], ["13", "14", "15", "16"]]
    /// The delegate that the View Controller will conform to in some way, so that the Game Engine
    /// View Model can call.
    weak var delegate: GridGameViewControllerDelegate?
    /// Specifies the current score of the game. If the game has not started, it will be the initial
    /// displayed score.
    private(set) var currentScore: Int = 0
    /// The timer of this game.
    private(set) var timer = CountDownTimer(totalTimeAllowed: 0, viewModel: nil)
    /// Specifies the remaining time left in the game.
    private(set) var timeRemaining: TimeInterval = Constants.Grid.time
    /// Specifies the total time allowed in the game.
    private(set) var totalTimeAllowed: TimeInterval = Constants.Grid.time
    /// The status of the current game.
    var gameStatus: GameStatus = .notStarted {
        didSet {
            delegate?.notifyGameStatus()
        }
    }

    /// Tells the view model that the game has started.
    func startGame() {
        loadGrid(from: answers)
        timer = CountDownTimer(totalTimeAllowed: totalTimeAllowed, viewModel: self)
        timer.startTimer(timerInterval: 1)
    }

    /// Tells the VM that the time has been updated.
    ///
    /// - Parameters:
    ///   - timeRemaining: the remaining time
    ///   - totalTime: the total time
    func timeDidUpdate(timeRemaining: TimeInterval, totalTime: TimeInterval) {
        delegate?.redisplay(timeRemaining: timeRemaining, outOf: totalTime)
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

        swap(&gridData[coord1], &gridData[coord2])

        if gridDone {
            gameStatus = .endedWithWon
        }

        return true
    }

    /// Returns true iff the grid is done (a.k.a. the game is won)
    private var gridDone: Bool {
        let sortedGrid = gridData
            .sorted { $0.key.compareByRowFirst($1.key) }
            .map { $0.value }

        var temporary: [String] = []
        for element in sortedGrid {
            temporary.append(element)
            if temporary.count == Constants.Grid.columns {
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

        delegate?.updateGridData()
        delegate?.redisplayAllTiles()
    }
}
