import Foundation

/// The main view model for Tetris game
class TetrisGameViewModel {

    weak var scoreDelegate: ScoreUpdateDelegate?
    weak var timeDelegate: TimeUpdateDelegate?
    weak var gameStatusDelegate: GameStatusUpdateDelegate?

    /// Provides a list of phrases that is being tested in this game.
    private(set) var phrasesTested: Set<Phrase> = []

    private(set) var currentScore: Int = 0 {
        didSet {
            scoreDelegate?.scoreDidUpdate()
        }
    }

    fileprivate let timer = CountDownTimer(totalTimeAllowed: Constants.Game.Tetris.totalTime)

    fileprivate(set) var gameStatus = GameStatus.notStarted {
        didSet {
            gameStatusDelegate?.gameStatusDidUpdate()
        }
    }

    fileprivate(set) var gridData = TextGrid(numRows: Constants.Game.Tetris.rows,
                                             numColumns: Constants.Game.Tetris.columns)

    fileprivate(set) var upcomingTiles: [String] = []
    fileprivate(set) var fallingTileText: String!

    private let gameData: GameData
    private var nextTexts: [String] = []

    /// Populate upcomingTiles and set listeners for the timer
    required init(gameData: GameData) {
        self.gameData = gameData
        populateUpcomingTiles()
        setNextFallingTile()
        setTimerListener()
    }

    private func populateUpcomingTiles() {
        for _ in 0..<Constants.Game.Tetris.upcomingTilesCount {
            upcomingTiles.append(getNextText())
        }
    }

    fileprivate func setNextFallingTile() {
        upcomingTiles.append(getNextText())
        fallingTileText = upcomingTiles.removeFirst()
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

    /// Checks for and returns coordinates of matching phrase
    /// search row-wise first as destroying rows are relatively more important than columns in Tetris
    /// if no row-wise match, column-wise search will proceed
    ///
    /// - Parameter coordinate: the coordinate at which a cell has been shifted or added to
    /// - Returns: the set of coordinates that contains the matching phrase
    private func checkForMatchingPhrase(at coordinate: Coordinate) -> Set<Coordinate>? {
        return checkForMatchingPhrase(at: coordinate, rowWise: true) ??
               checkForMatchingPhrase(at: coordinate, rowWise: false)
    }

    private func checkForMatchingPhrase(at coordinate: Coordinate, rowWise: Bool) -> Set<Coordinate>? {
        let phraseLen = gameData.phrases.phraseLength
        let rowOrCol = rowWise ? coordinate.col : coordinate.row
        let startIndex = max(0, rowOrCol - phraseLen + 1)
        let endIndex = min((rowWise ? gridData.numColumns : gridData.numRows) - phraseLen, rowOrCol)
        for index in startIndex...endIndex {
            let phraseRange = index..<(index + phraseLen)
            let coordinates = phraseRange.map {
                rowWise ? Coordinate(row: coordinate.row, col: $0) : Coordinate(row: $0, col: coordinate.col)
            }
            if isPhraseValid(at: coordinates) {
                return Set(coordinates)
            }
        }

        return nil
    }

    /// Concatenate the tile texts at `coordinates` and check if it is a valid phrase
    private func isPhraseValid(at coordinates: [Coordinate]) -> Bool {
        guard let phrase = gridData.getConcatenatedTexts(at: coordinates) else {
            return false
        }
        return gameData.phrases.contains(chinese: phrase)
    }

    /// Shifts all the tiles above `coordinates` 1 row down.
    /// Starts from the row right above the coordinates so that it can break once an empty tile is encountered
    ///
    /// Returns: array of coordinates shifted from `from` to `to`
    private func shiftDownTiles(_ coordinates: Set<Coordinate>) -> [(from: Coordinate, to: Coordinate)] {
        var shiftedTiles: [(from: Coordinate, to: Coordinate)] = []
        for coordinate in coordinates {
            for row in (0..<coordinate.row).reversed() {
                let currentCoordinate = Coordinate(row: row, col: coordinate.col)
                guard gridData.hasText(at: currentCoordinate) else {
                    break
                }
                let newCoordinate = currentCoordinate.nextRow
                gridData.swap(currentCoordinate, newCoordinate)
                shiftedTiles.append((from: currentCoordinate, to: newCoordinate))
            }
        }
        return shiftedTiles
    }

    private func getNextText() -> String {
        if nextTexts.isEmpty {
            let newPhrases = (0..<Constants.Game.Tetris.upcomingPhrasesCount).map { _ in
                gameData.phrases.next()
            }
            phrasesTested.formUnion(newPhrases)
            nextTexts += newPhrases.map { $0.chinese }.flatMap { $0 }
        }
        let randInt = Random.integer(toExclusive: nextTexts.count)
        return nextTexts.remove(at: randInt)
    }

    fileprivate func checkIfGameOver(landedAt coordinate: Coordinate) {
        if coordinate.row == Coordinate.origin.row {
            gameStatus = .endedWithLost
        }
    }

    fileprivate func destroyAndShiftTiles(landedAt coordinate: Coordinate) ->
            [(destroyedTiles: Set<Coordinate>, shiftedTiles: [(from: Coordinate, to: Coordinate)])] {
        var destroyedAndShiftedTiles: [(destroyedTiles: Set<Coordinate>,
                                        shiftedTiles: [(from: Coordinate, to: Coordinate)])] = []
        var changedCoordinates: Set<Coordinate> = []
        changedCoordinates.insert(coordinate)
        while let nextCoordinate = changedCoordinates.popFirst() {
            guard let destroyedTiles = checkForMatchingPhrase(at: nextCoordinate) else {
                continue
            }
            destroyedTiles.forEach { changedCoordinates.remove($0) }
            gridData.removeTexts(at: destroyedTiles)
            currentScore += destroyedTiles.count

            let shiftedTiles = shiftDownTiles(destroyedTiles)
            changedCoordinates.formUnion(shiftedTiles.map { $0.to })
            destroyedAndShiftedTiles.append((destroyedTiles: destroyedTiles, shiftedTiles: shiftedTiles))
        }
        return destroyedAndShiftedTiles
    }
}

extension TetrisGameViewModel: TetrisGameViewModelProtocol {

    var fallingTileStartCoordinate: Coordinate {
        let randCol = Random.integer(toExclusive: gridData.numColumns)
        return Coordinate(row: Coordinate.origin.row, col: randCol)
    }

    func canShiftFallingTile(to coordinate: Coordinate) -> Bool {
        return !gridData.hasText(at: coordinate)
    }

    func canLandTile(at coordinate: Coordinate) -> Bool {
        let isNextRowOccupied = (coordinate.row == gridData.numRows - 1) || gridData.hasText(at: coordinate.nextRow)
        return isNextRowOccupied && canShiftFallingTile(to: coordinate)
    }

    func getLandingCoordinate(from coordinate: Coordinate) -> Coordinate {
        for row in (coordinate.row + 1)..<gridData.numRows {
            let landingCoordinate = Coordinate(row: row, col: coordinate.col)
            if canLandTile(at: landingCoordinate) {
                return landingCoordinate
            }
        }
        fatalError("Failed to find landing coordinate")
    }

    func landTile(at coordinate: Coordinate) -> [(destroyedTiles: Set<Coordinate>,
                                                  shiftedTiles: [(from: Coordinate, to: Coordinate)])] {
        gridData[coordinate] = fallingTileText
        setNextFallingTile()

        let destroyedAndShiftedTiles = destroyAndShiftTiles(landedAt: coordinate)

        if destroyedAndShiftedTiles.isEmpty {
            checkIfGameOver(landedAt: coordinate)
        }

        return destroyedAndShiftedTiles
    }

    func swapFallingTile(withUpcomingAt index: Int) {
        assert(index < upcomingTiles.count, "Index of upcoming tile is out of bounds")
        let upcomingTileText = upcomingTiles[index]
        upcomingTiles[index] = fallingTileText
        fallingTileText = upcomingTileText
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

extension TetrisGameViewModel: GameDescriptorProtocol {
    // TODO : should be set from gameData instead
    var gameTitle: String {
        return Constants.Game.Tetris.gameTitle
    }
    var gameInstruction: String {
        return Constants.Game.Tetris.gameInstruction
    }
}
