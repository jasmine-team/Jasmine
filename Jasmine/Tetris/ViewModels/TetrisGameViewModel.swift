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

    fileprivate let timer = CountDownTimer(totalTimeAllowed: GameConstants.Tetris.totalTime)

    fileprivate(set) var gameStatus = GameStatus.notStarted {
        didSet {
            gameStatusDelegate?.gameStatusDidUpdate()
        }
    }

    fileprivate(set) var gridData = TextGrid(numRows: GameConstants.Tetris.rows,
                                             numColumns: GameConstants.Tetris.columns)

    fileprivate(set) var upcomingTiles: [String] = []
    fileprivate(set) var fallingTileText: String!

    private let gameData: GameData

    // Stores the pool of upcoming texts shuffled randomly to pick from for the new pcoming tile
    private var nextTexts: [String] = []
    // Stores the current index of `nextTexts` for the new upcoming tile
    private var nextTextIndex: Int = 0

    /// Populate upcomingTiles and set listeners for the timer
    required init(gameData: GameData) {
        self.gameData = gameData
        populateUpcomingTiles()
        setNextFallingTile()
        setTimerListener()
    }

    private func populateUpcomingTiles() {
        for _ in 0..<GameConstants.Tetris.upcomingTilesCount {
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
    /// If a match is found, adds all coordinates on the grid 
    /// with text that is contained in the matching phrase to the result
    ///
    /// - Parameter coordinate: the coordinate at which a cell has been shifted or added to
    /// - Returns: the set of coordinates that contains the matching phrase
    private func checkForMatchingPhrase(at coordinate: Coordinate) -> Set<Coordinate>? {
        return checkForMatchingPhrase(at: coordinate, rowWise: true) ??
               checkForMatchingPhrase(at: coordinate, rowWise: false)
    }

    private func checkForMatchingPhrase(at coordinate: Coordinate, rowWise: Bool) -> Set<Coordinate>? {
        let phraseLen = gameData.phrases[0].chinese.count
        let rowOrCol = rowWise ? coordinate.col : coordinate.row
        let startIndex = max(0, rowOrCol - phraseLen + 1)
        let endIndex = min((rowWise ? gridData.numColumns : gridData.numRows) - phraseLen, rowOrCol)
        for index in startIndex...endIndex {
            let phraseRange = index..<(index + phraseLen)
            let coordinates = phraseRange.map {
                rowWise ? Coordinate(row: coordinate.row, col: $0) : Coordinate(row: $0, col: coordinate.col)
            }
            if let phrase = isPhraseValid(at: coordinates) {
                return Set(coordinates).union(gridData.getCoordinates(containing: Set(phrase)))
            }
        }

        return nil
    }

    /// Gets the tile texts at `coordinates` and check if it is a valid phrase
    private func isPhraseValid(at coordinates: [Coordinate]) -> [String]? {
        guard let phrase = gridData.getTexts(at: coordinates) else {
            return nil
        }
        return gameData.phrases.contains(chinese: phrase.joined()) ? phrase : nil
    }

    /// Shifts all the tiles above `coordinates` 1 row down.
    /// Starts from the row right above the coordinates so that it can break once an empty tile is encountered
    ///
    /// - Returns: array of coordinates shifted from `from` to `to`
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

    /// Returns the next text for a new upcoming tile.
    /// if current text pool is exhausted, a new text pool will be generated and randomly shuffled
    private func getNextText() -> String {
        if nextTextIndex == nextTexts.count {
            nextTextIndex = 0
            nextTexts = (getFailedTexts() ?? getNewTexts()).shuffled()
        }

        let nextText = nextTexts[nextTextIndex]
        nextTextIndex += 1
        return nextText
    }

    /// Finds a text on the grid that is not in `nextTexts` 
    /// i.e. player has failed to correctly destroy the phrase associated with the text when it was dropped.
    /// currentScore will be deducted accordingly so that the subsequent destruction does not award any point
    ///
    /// - Returns: a phrase containing that text from the phrase tested set
    private func getFailedTexts() -> [String]? {
        guard let failedText = gridData.texts.subtracting(nextTexts).first else {
            return nil
        }

        for phrase in phrasesTested {
            let texts = phrase.chinese
            if texts.contains(failedText) {
                currentScore = max(0, currentScore - GameConstants.Tetris.scoreIncrement)
                return texts
            }
        }

        fatalError("Could not find failed text in phrasesTested")
    }

    /// Returns `Constants.Game.Tetris.upcomingPhrasesCount` number of new phrases and add them to the phrases tested
    private func getNewTexts() -> [String] {
        let count = GameConstants.Tetris.upcomingPhrasesCount
        let newPhrases = gameData.phrases.randomGenerator.next(count: count)
        phrasesTested.formUnion(newPhrases)
        return newPhrases.map { $0.chinese }.flatMap { $0 }
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
            currentScore += GameConstants.Tetris.scoreIncrement
            changedCoordinates.subtract(destroyedTiles)
            gridData.removeTexts(at: destroyedTiles)

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
        for row in coordinate.row..<gridData.numRows {
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
        timer.startTimer(timerInterval: GameConstants.timeInterval)
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
        return GameConstants.Tetris.gameTitle
    }
    var gameInstruction: String {
        return GameConstants.Tetris.gameInstruction
    }
}
