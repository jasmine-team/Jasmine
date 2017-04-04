import Foundation

/// The main view model for Tetris game
class TetrisGameViewModel {
    /// Provides a list of phrases that is being tested in this game.
    // TODO: add accordingly
    var phrasesTested: [Phrase] = []

    weak var delegate: TetrisGameViewControllerDelegate?
    weak var scoreDelegate: ScoreUpdateDelegate?
    weak var timeDelegate: TimeUpdateDelegate?
    weak var gameStatusDelegate: GameStatusUpdateDelegate?

    fileprivate var grid = TextGrid(numRows: Constants.Game.Tetris.rows, numColumns: Constants.Game.Tetris.columns)

    fileprivate(set) var upcomingTiles: [String] = []
    fileprivate var fallingTileText: String?
    fileprivate var landingCoordinate: Coordinate?

    fileprivate(set) var currentScore: Int = 0 {
        didSet {
            scoreDelegate?.scoreDidUpdate()
        }
    }

    let timer = CountDownTimer(totalTimeAllowed: Constants.Game.Tetris.totalTime)

    private(set) var gameStatus = GameStatus.notStarted {
        didSet {
            delegate?.gameStatusDidUpdate()
        }
    }

    private let gameData: GameData
    private var nextTexts: [String] = []

    // TODO : should be set from gameData instead
    var gameTitle: String {
        return Constants.Game.Tetris.gameTitle
    }
    var gameInstruction: String {
        return Constants.Game.Tetris.gameInstruction
    }

    /// Populate upcomingTiles and set listeners for the timer
    required init(gameData: GameData) {
        self.gameData = gameData
        populateUpcomingTiles()
        setTimerListener()
    }

    private func populateUpcomingTiles() {
        for _ in 0..<Constants.Game.Tetris.upcomingTilesCount {
            upcomingTiles.append(getNextText())
        }
    }

    private func setTimerListener() {
        timer.timerListener = { status in
            switch status {
            case .start:
                self.gameStatus = .inProgress
                self.timeDelegate?.timeDidUpdate()
            case .tick:
                self.timeDelegate?.timeDidUpdate()
            case .finish:
                self.gameStatus = .endedWithLost
            case .stop:
                self.gameStatus = .endedWithWon
            }
        }
    }

    /// Checks for and returns coordinates of matching phrase, searching by row-wise then column-wise
    fileprivate func checkForMatchingPhrase() -> Set<Coordinate>? {
        let phraseLen = gameData.phrases.phraseLength
        for row in 0..<Constants.Game.Tetris.rows {
            for col in 0..<(Constants.Game.Tetris.columns - phraseLen) {
                let phraseRange = col..<(col + phraseLen)
                let coordinates = phraseRange.map { Coordinate(row: row, col: $0) }
                if isPhraseValid(at: coordinates) {
                    return Set(coordinates)
                }
            }
        }

        for col in 0..<Constants.Game.Tetris.columns {
            for row in 0..<(Constants.Game.Tetris.rows - phraseLen) {
                let phraseRange = row..<(row + phraseLen)
                let coordinates = phraseRange.map { Coordinate(row: $0, col: col) }
                if isPhraseValid(at: coordinates) {
                    return Set(coordinates)
                }
            }
        }

        return nil
    }

    /// Concatenate the tile texts at `coordinates` and check if it is a valid phrase
    private func isPhraseValid(at coordinates: [Coordinate]) -> Bool {
        guard let phrase = grid.getConcatenatedTexts(at: coordinates) else {
            return false
        }
        return gameData.phrases.contains(chinese: phrase)
    }

    /// Shifts all the tiles above `coordinates` 1 row down.
    /// Starts from the row right above the coordinates so that it can break once an empty tile is encountered
    ///
    /// Returns: array of coordinates shifted from `from` to `to`
    fileprivate func shiftDownTiles(_ coordinates: Set<Coordinate>) -> [(from: Coordinate, to: Coordinate)] {
        var shiftedTiles: [(from: Coordinate, to: Coordinate)] = []
        for coordinate in coordinates {
            for row in (0..<coordinate.row).reversed() {
                let currentCoordinate = Coordinate(row: row, col: coordinate.col)
                guard grid.hasText(at: currentCoordinate) else {
                    break
                }
                let newCoordinate = currentCoordinate.nextRow
                grid.swap(currentCoordinate, newCoordinate)
                shiftedTiles.append((from: currentCoordinate, to: newCoordinate))
            }
        }
        return shiftedTiles
    }

    fileprivate func getNextText() -> String {
        if nextTexts.isEmpty {
            nextTexts = gameData.phrases.next().chinese.characters.map { String($0) }
        }
        let randInt = Random.integer(toExclusive: nextTexts.count)
        return nextTexts.remove(at: randInt)
    }
}

extension TetrisGameViewModel: TetrisGameViewModelProtocol {
    var gridData: TextGrid {
        return grid
    }

    func canShiftFallingTile(to coordinate: Coordinate) -> Bool {
        return !grid.hasText(at: coordinate)
    }

    func dropNextTile() -> (location: Coordinate, tileText: String) {
        upcomingTiles.append(getNextText())
        let tileText = upcomingTiles.removeFirst()
        delegate?.redisplayUpcomingTiles()

        fallingTileText = tileText
        let randCol = Random.integer(toExclusive: Constants.Game.Tetris.columns)
        return (location: Coordinate(row: Coordinate.origin.row, col: randCol),
                tileText: tileText)
    }

    func canLandTile(at coordinate: Coordinate) -> Bool {
        let isNextRowOccupied = (coordinate.row == grid.numRows - 1) || grid.hasText(at: coordinate.nextRow)
        if !isNextRowOccupied || grid.hasText(at: coordinate) {
            return false
        }
        landingCoordinate = coordinate
        return true
    }

    func tileHasLanded() {
        guard let fallingTileText = fallingTileText,
              let landingCoordinate = landingCoordinate else {
            fatalError("fallingTileText or landingCoordinate is not initialised")
        }
        grid[landingCoordinate] = fallingTileText

        guard let destroyedTiles = checkForMatchingPhrase() else {
            return
        }
        grid.removeTexts(at: destroyedTiles)
        currentScore += destroyedTiles.count

        let shiftedTiles = shiftDownTiles(destroyedTiles)
        delegate?.animate(destroyedTiles: destroyedTiles, shiftedTiles: shiftedTiles)
    }

    func swapFallingTile(withUpcomingAt index: Int) {
        guard let currentFallingTileText = fallingTileText else {
            assertionFailure("fallingTileText is not initialised")
            return
        }
        assert(index < upcomingTiles.count, "Index of upcoming tile is out of bounds")
        fallingTileText = upcomingTiles[index]
        delegate?.redisplayFallingTile(tileText: upcomingTiles[index])

        upcomingTiles[index] = currentFallingTileText
        delegate?.redisplayUpcomingTiles()
    }

    func startGame() {
        guard gameStatus == .notStarted else {
            assertionFailure("startGame called when game is already ongoing")
            return
        }
        timer.startTimer(timerInterval: Constants.Game.timeInterval)
    }
}

extension TetrisGameViewModel: TimeDescriptorProtocol {
    var timeRemaining: TimeInterval {
        return timer.timeRemaining
    }

    var totalTimeAllowed: TimeInterval {
        return timer.totalTimeAllowed
    }
}
