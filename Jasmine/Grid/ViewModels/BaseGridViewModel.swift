import Foundation

class BaseGridViewModel: GridViewModelProtocol {
    /// Stores the grid data that will be used to display in the view controller.
    private(set) var gridData: [Coordinate: String] = [:] {
        didSet {
            delegate?.updateGridData()
        }
    }
    /// Tiles for this game. Will be randomized.
    private let tiles: [String]
    /// Possible answers in this game. The game is won when all rows in the grid is in this possibleAnswers.
    private let possibleAnswers: [[String]]
    /// Number of rows in the grid, according to the answers property
    let numRows: Int
    /// Number of columns in the grid, according to the answers property
    let numColumns: Int
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
    private(set) var timer: CountDownTimer
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
    var gameTitle: String
    /// Provide of a brief description of its objectives and how this game is played.
    /// There is no word count limit, but should be concise.
    var gameInstruction: String

    /// Initializes the grid VM.
    ///
    /// - Parameters:
    ///   - time: total time allowed
    ///   - tiles: tiles in the game
    ///   - possibleAnswers: all possible answers. The game is won if all rows in the game is in all possible answers.
    ///   - rows: number of rows in the grid.
    ///   - columns: number of columns in the grid.
    init(time: TimeInterval, tiles: [String], possibleAnswers: [[String]], rows: Int, columns: Int) {
        assert(rows > 0 && columns > 0, "Number of rows and columns should be more than 0")
        assert(tiles.count == rows * columns, "Number of tiles should equal numRows * numColumns")
        assert(possibleAnswers.map { $0.count }.isAllSame, "All rows in possible answers should have the same length")
        assert(possibleAnswers[0].count == columns, "Possible answers rows length should equal # of columns")
        assert(Set(possibleAnswers.flatMap { $0 }) == Set(tiles), "Possible answers and tiles should've same char set")

        gameTitle = "Grid Game"
        gameInstruction = "Match the Chinese characters with their Pinyins by putting them in one row."

        self.tiles = tiles
        self.possibleAnswers = possibleAnswers
        numRows = rows
        numColumns = columns

        timer = CountDownTimer(totalTimeAllowed: time)
        timer.timerListener = gridTimerListener

        loadGrid()
    }

    /// Tells the view model that the game has started.
    func startGame() {
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
    @discardableResult
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

        var temporary: [String] = []
        for element in sortedGrid {
            temporary.append(element)
            if temporary.count == Constants.Game.Grid.columns {
                if possibleAnswers.contains(where: { $0 == temporary }) {
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
    private func loadGrid() {
        let allTiles = tiles.shuffled()

        // Place back allTiles to the grid
        gridData.removeAll()
        var idx = 0
        for row in 0..<numRows {
            for col in 0..<numColumns {
                gridData[Coordinate(row: row, col: col)] = allTiles[idx]
                idx += 1
            }
        }
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
    private func gridTimerListener(status: TimerStatus) {
        switch status {
        case .start:
            gameStatus = .inProgress
            delegate?.redisplay(timeRemaining: timeRemaining, outOf: totalTimeAllowed)
        case .tick:
            delegate?.redisplay(timeRemaining: timeRemaining, outOf: totalTimeAllowed)
        case .finish:
            gameStatus = .endedWithLost
        default:
            break
        }
    }
}
