import Foundation

/// The main view model for Tetris game
class TetrisGameViewModel {

    weak var delegate: TetrisGameViewControllerDelegate?

    fileprivate var tetrisGrid = TetrisGrid()

    fileprivate(set) var upcomingTiles: [String] = []
    fileprivate var fallingTileText: String?
    fileprivate var landingCoordinate: Coordinate?

    fileprivate(set) var currentScore: Int = 0 {
        didSet {
            delegate?.redisplay(newScore: currentScore)
        }
    }

    let timer = CountDownTimer(totalTimeAllowed: Constants.Game.Tetris.totalTime)

    private(set) var gameStatus = GameStatus.notStarted {
        didSet {
            delegate?.notifyGameStatusUpdated()
        }
    }

    /// Populate upcomingTiles and set listeners for the timer
    init() {
        populateUpcomingTiles()
        setTimerListener()
    }

    private func populateUpcomingTiles() {
        for _ in 0..<Constants.Game.Tetris.upcomingTilesCount {
            upcomingTiles.append(getRandomWord())
        }
    }

    private func setTimerListener() {
        timer.timerListener = { status in
            switch status {
            case .start:
                self.gameStatus = .inProgress
                self.delegate?.redisplay(timeRemaining: self.timeRemaining, outOf: self.totalTimeAllowed)
            case .tick:
                self.delegate?.redisplay(timeRemaining: self.timeRemaining, outOf: self.totalTimeAllowed)
            case .finish:
                self.gameStatus = .endedWithLost
            case .stop:
                self.gameStatus = .endedWithWon
            }
        }
    }

    /// Checks for and returns coordinates of matching phrase, searching by row-wise and return if found
    /// otherwise continue with searching by column-wise
    fileprivate func checkForMatchingPhrase() -> Set<Coordinate>? {
        return checkForMatchingPhrase(byRow: true) ?? checkForMatchingPhrase(byRow: false)
    }

    /// Checks for and returns coordinates of matching phrase, search row/col-wise as specify by searchbyRow
    /// Concatenate the words row by row or col by col to check if a phrase is contained in them
    private func checkForMatchingPhrase(byRow searchByRow: Bool) -> Set<Coordinate>? {
        var matchedCoordinates: Set<Coordinate> = []
        let maxIndex = searchByRow ? Constants.Game.Tetris.rows : Constants.Game.Tetris.columns
        for index in 0..<maxIndex {
            var line = ""
            if searchByRow {
                for col in 0..<Constants.Game.Tetris.columns {
                    line += getTileText(at: Coordinate(row: index, col: col))
                }
            } else {
                for row in 0..<Constants.Game.Tetris.rows {
                    line += getTileText(at: Coordinate(row: row, col: index))
                }
            }

            guard let validPhraseRange = getValidPhraseRange(line) else {
                continue
            }

            for i in validPhraseRange {
                let coordinate = searchByRow ? Coordinate(row: index, col: i) : Coordinate(row: i, col: index)
                matchedCoordinates.insert(coordinate)
            }
            return matchedCoordinates
        }
        return nil
    }

    /// Gets the tile text at coordinate specified by `row` and `col`
    /// returns " " if no tile is present so that phrases separated by gaps don't get matched
    private func getTileText(at coordinate: Coordinate) -> String {
        return tetrisGrid.getTileText(at: coordinate) ?? " "
    }

    /// Shifts all the tiles above `coordinates` 1 row down.
    /// Starts from the row right above the coordinates so that it can break once an empty tile is encountered
    fileprivate func shiftDownTiles(_ coordinates: Set<Coordinate>) {
        var coordinatesToShift: [(from: Coordinate, to: Coordinate)] = []
        for coordinate in coordinates {
            for row in (0..<coordinate.row).reversed() {
                let currentCoordinate = Coordinate(row: row, col: coordinate.col)
                guard let text = tetrisGrid.removeTile(at: currentCoordinate) else {
                    break
                }
                let newCoordinate = currentCoordinate.nextRow
                tetrisGrid.addTile(at: newCoordinate, tileText: text)
                coordinatesToShift.append((from: currentCoordinate, to: newCoordinate))
            }
        }
        delegate?.animate(shiftTiles: coordinatesToShift)
    }

    // TODO: fetch from database to match valid phrase
    private func getValidPhraseRange(_ line: String) -> CountableRange<Int>? {
        let phrases = ["先发制人"]
        for phrase in phrases {
            let phraseLen = phrase.characters.count
            for i in 0...line.characters.count - phraseLen {
                let startIndex = line.index(line.startIndex, offsetBy: i)
                if line[startIndex..<line.index(startIndex, offsetBy: phraseLen)] == phrase {
                    return i..<i + phraseLen
                }
            }
        }
        return nil
    }

    // TODO: generate from database, base on existing grid
    fileprivate func getRandomWord() -> String {
        let words = "先发制人"
        return String(words[words.index(words.startIndex,
                                        offsetBy: Random.integer(toInclusive: words.characters.count))])
    }

    @inline(__always)
    fileprivate func assertCoordinateValid(_ coordinate: Coordinate) {
        assert(coordinate.row < Constants.Game.Tetris.rows &&
               coordinate.col < Constants.Game.Tetris.columns, "Coordinate is out of bounds")
    }
}

extension TetrisGameViewModel: TetrisGameViewModelProtocol {

    var gameTitle: String {
        return Constants.Game.Tetris.gameTitle
    }

    var gameInstruction: String {
    	return Constants.Game.Tetris.gameInstruction
    }

    func canShiftFallingTile(to coordinate: Coordinate) -> Bool {
        assertCoordinateValid(coordinate)
        return !tetrisGrid.hasTile(at: coordinate)
    }

    func dropNextTile() -> (location: Coordinate, tileText: String) {
        upcomingTiles.append(getRandomWord())
        let tileText = upcomingTiles.removeFirst()
        delegate?.redisplayUpcomingTiles()

        fallingTileText = tileText
        let randCol = Random.integer(toInclusive: Constants.Game.Tetris.columns)
        return (location: Coordinate(row: Coordinate.origin.row, col: randCol),
                tileText: tileText)
    }

    func canLandTile(at coordinate: Coordinate) -> Bool {
        assertCoordinateValid(coordinate)
        if tetrisGrid.hasTile(at: coordinate) ||
           (!tetrisGrid.hasTile(at: coordinate.nextRow) && coordinate.row < Constants.Game.Tetris.rows - 1) {
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
        tetrisGrid.addTile(at: landingCoordinate, tileText: fallingTileText)

        guard let destroyedCoordinates = checkForMatchingPhrase() else {
            return
        }
        tetrisGrid.removeTiles(at: destroyedCoordinates)
        delegate?.animate(destroyTilesAt: destroyedCoordinates)

        currentScore += destroyedCoordinates.count

        shiftDownTiles(destroyedCoordinates)
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
        timer.startTimer(timerInterval: Constants.Game.Tetris.timeInterval)
    }
}
