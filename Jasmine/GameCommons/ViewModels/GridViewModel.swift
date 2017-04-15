import Foundation

class GridViewModel: GridViewModelProtocol {
    weak var timeDelegate: TimeUpdateDelegate?
    weak var scoreDelegate: ScoreUpdateDelegate?
    weak var gameStatusDelegate: GameStatusUpdateDelegate?
    weak var highlightedDelegate: HighlightedUpdateDelegate?

    /// Stores the grid data that will be used to display in the view controller.
    var gridData: TextGrid
    /// Specifies the current score of the game. If the game has not started, it will be the initial
    /// displayed score.
    var currentScore: Int = 0 {
        didSet {
            scoreDelegate?.scoreDidUpdate()
        }
    }

    /// Highlighted coordinates in the grid.
    var highlightedCoordinates: Set<Coordinate> = [] {
        didSet {
            highlightedDelegate?.highlightedCoordinatesDidUpdate()
        }
    }

    /// Provides a list of phrases that is being tested in this game.
    /// This is to be overriden in subclasses
    var phrasesTested: Set<Phrase> = []

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
    var gameTitle: String {
        fatalError("Game title not overriden")
    }
    /// Provide of a brief description of its objectives and how this game is played.
    /// There is no word count limit, but should be concise.
    var gameInstruction: String {
        fatalError("Game instruction not overriden")
    }

    /// The game type. To be overriden.
    var gameType: GameType

    /// Initializes the grid VM.
    ///
    /// - Parameters:
    ///   - time: the time allowed
    ///   - gameData: the game data
    ///   - tiles: the tiles in the game, will be shuffled
    ///   - rows: number of rows
    ///   - columns: number of columns
    init(time: TimeInterval, gameData: GameData, gameType: GameType, tiles: [String?], rows: Int, columns: Int) {
        assert(rows > 0 && columns > 0, "Number of rows and columns should be more than 0")
        assert(tiles.count == rows * columns, "Number of tiles should equal numRows * numColumns")

        let shuffledTiles = tiles.shuffled()
        let grid = (0..<rows).map { row in
            (0..<columns).map { col in
                shuffledTiles[row * columns + col]
            }
        }

        self.gameData = gameData
        self.gameType = gameType
        gridData = TextGrid(fromInitialGrid: grid)

        timer = CountDownTimer(totalTimeAllowed: time)
        timer.timerListener = gridTimerListener
    }

    /// Starts the game.
    func startGame() {
        timer.startTimer(timerInterval: GameConstants.timeInterval)
        scoreDelegate?.scoreDidUpdate()
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

    /// Returns true if and only if the given line is valid.
    /// By default, this means that the characters concatenated from the coordinates are in the database.
    /// For cihui, the row/column contains the cihui and the respective pinyin.
    func lineIsCorrect(_ line: [Coordinate]) -> Bool {
        let gameType: GameType = self.gameType
        switch gameType {
        case .ciHui:
            let firstHalfCoordinates = Array(line[0..<(line.count / 2)])
            let secondHalfCoordinates = Array(line[(line.count / 2)..<line.count])

            let possibleArrangements = [
                (firstHalfCoordinates, secondHalfCoordinates),
                (secondHalfCoordinates, firstHalfCoordinates)
            ]
            for (first, second) in possibleArrangements {
                if let text = gridData.getConcatenatedTexts(at: first),
                    let phrase = gameData.phrases.first(whereChinese: text),
                    let pinyin = gridData.getTexts(at: second),
                    phrase.pinyin == pinyin {
                    return true
                }
            }
            return false
        default:
            guard let text = gridData.getConcatenatedTexts(at: line),
                  gameData.phrases.contains(chinese: text) else {
                return false
            }
            return true
        }
    }
}
