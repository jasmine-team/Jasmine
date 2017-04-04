import Foundation

class GridViewModel: BaseViewModelProtocol {
    weak var timeDelegate: TimeUpdateDelegate?
    weak var scoreDelegate: ScoreUpdateDelegate?
    weak var gameStatusDelegate: GameStatusUpdateDelegate?

    /// Stores the grid data that will be used to display in the view controller.
    var gridData: TextGrid
    /// Number of rows in the grid, according to the answers property
    var numRows: Int {
        return gridData.numRows
    }
    /// Number of columns in the grid, according to the answers property
    var numColumns: Int {
        return gridData.numColumns
    }
    /// Specifies the current score of the game. If the game has not started, it will be the initial
    /// displayed score.
    private(set) var currentScore: Int = 0 {
        didSet {
            scoreDelegate?.scoreDidUpdate()
        }
    }

    /// Provides a list of phrases that is being tested in this game.
    /// This is to be overriden in subclasses
    var phrasesTested: [Phrase] = []

    /// The timer of this game.
    var timer: CountDownTimer

    var timeRemaining: TimeInterval {
        return timer.timeRemaining
    }

    var totalTimeAllowed: TimeInterval {
        return timer.totalTimeAllowed
    }

    /// The status of the current game.
    var gameStatus: GameStatus = .notStarted {
        didSet {
            gameStatusDelegate?.gameStatusDidUpdate()

            if gameStatus == .endedWithWon {
                timer.stopTimer()
            }
        }
    }
    /// The game data of this game.
    let gameData: GameData

    /// Provide a brief title for this game. Note that this title should be able to fit within the
    /// width of the display.
    var gameTitle: String = ""
    /// Provide of a brief description of its objectives and how this game is played.
    /// There is no word count limit, but should be concise.
    var gameInstruction: String = ""

    /// Initializes the grid VM.
    ///
    /// - Parameters:
    ///   - time: total time allowed
    ///   - tiles: tiles in the game
    ///   - possibleAnswers: all possible answers. The game is won if all rows in the game is in all possible answers.
    ///   - rows: number of rows in the grid.
    ///   - columns: number of columns in the grid.
    init(time: TimeInterval, gameData: GameData, textGrid: TextGrid) {
        self.gameData = gameData
        gridData = textGrid

        timer = CountDownTimer(totalTimeAllowed: time)
        timer.timerListener = gridTimerListener
    }

    /// Starts the game.
    func startGame() {
        timer.startTimer(timerInterval: Constants.Game.timeInterval)
        scoreDelegate?.scoreDidUpdate()
    }

    /// Check what happens when game is won. If game is won, change game status and add score.
    func checkGameWon() {
        if hasGameWon {
            gameStatus = .endedWithWon
            currentScore += score
        }
    }

    /// Score for the game when it is won on the current state. To be overriden.
    var score: Int {
        return 0
    }

    /// Returns true iff the game is won.
    private var hasGameWon: Bool {
        let allRowsCorrect = (0..<numRows).isAllTrue { row in
            lineIsCorrect((0..<numColumns).map { column in Coordinate(row: row, col: column) })
        }
        let allColumnsCorrect = (0..<numColumns).isAllTrue { column in
            lineIsCorrect((0..<numRows).map { row in Coordinate(row: row, col: column) })
        }

        return allRowsCorrect || allColumnsCorrect
    }

    /// Returns true iff the line given is correct. This is to be overriden.
    func lineIsCorrect(_ line: [Coordinate]) -> Bool {
        return false
    }

    /// The countdown timer for use in this ViewModel.
    ///
    /// - Returns: the countdown timer
    private func gridTimerListener(status: TimerStatus) {
        switch status {
        case .start:
            gameStatus = .inProgress
            timeDelegate?.timeDidUpdate()
        case .tick:
            timeDelegate?.timeDidUpdate()
        case .finish:
            gameStatus = .endedWithLost
        default:
            break
        }
    }
}
