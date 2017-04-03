import Foundation

/// The main view model for Tetris game
class TetrisGameViewModel {

    weak var delegate: BaseGameViewControllerDelegate?

    fileprivate let grid = TextGrid(numRows: Constants.Game.Tetris.rows, numColumns: Constants.Game.Tetris.columns)

    fileprivate(set) var upcomingTiles: [String] = []
    var fallingTileText: String! // Force unwrap so that self methods can be called in init
    fileprivate var landingCoordinate: Coordinate?

    fileprivate(set) var currentScore: Int = 0 {
        didSet {
            delegate?.redisplay(newScore: currentScore)
        }
    }

    let timer = CountDownTimer(totalTimeAllowed: Constants.Game.Tetris.totalTime)

    fileprivate(set) var gameStatus = GameStatus.notStarted {
        didSet {
            delegate?.notifyGameStatusUpdated()
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

    /// Checks for and returns coordinates of matching phrase
    /// search row-wise first as destroying rows are relatively more important than columns in Tetris
    /// if no row-wise match, column-wise search will proceed
    ///
    /// - Parameter coordinate: the coordinate that has been changed
    /// - Returns: the set of coordinates that contains the matching phrase
    fileprivate func checkForMatchingPhrase(at coordinate: Coordinate) -> Set<Coordinate>? {
        let phraseLen = gameData.phrases.phraseLength
        for col in (coordinate.col - phraseLen + 1)..<(coordinate.col + phraseLen) {
            let phraseRange = col..<(col + phraseLen)
            let coordinates = phraseRange.map { Coordinate(row: coordinate.row, col: $0) }
            if isPhraseValid(at: coordinates) {
                return Set(coordinates)
            }
        }

        for row in (coordinate.row - phraseLen + 1)..<(coordinate.row + phraseLen) {
            let phraseRange = row..<(row + phraseLen)
            let coordinates = phraseRange.map { Coordinate(row: $0, col: coordinate.col) }
            if isPhraseValid(at: coordinates) {
                return Set(coordinates)
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

    /// Checking if `coordinate` has text is not required 
    fileprivate func canLandTile(at coordinate: Coordinate) -> Bool {
        return (coordinate.row >= grid.numRows - 1) || grid.hasText(at: coordinate.nextRow)
    }
}

extension TetrisGameViewModel: TetrisGameViewModelProtocol {

    func canShiftFallingTile(to coordinate: Coordinate) -> Bool {
        return !grid.hasText(at: coordinate)
    }

    func getNewTileCoordinate() -> Coordinate {
        let randCol = Random.integer(toExclusive: grid.numColumns)
        return Coordinate(row: Coordinate.origin.row, col: randCol)
    }

    func tryLandTile(at coordinate: Coordinate) -> Bool {
        guard canLandTile(at: coordinate) else {
            return false
        }

        grid[coordinate] = fallingTileText
        setNextFallingTile()
        return true
    }

    func getDestroyedAndShiftedTiles(at coordinate: Coordinate) ->
            [(destroyedTiles: Set<Coordinate>, shiftedTiles: [(from: Coordinate, to: Coordinate)])] {
        var destroyedAndShiftedTiles: [(destroyedTiles: Set<Coordinate>,
                                        shiftedTiles: [(from: Coordinate, to: Coordinate)])] = []
        var changedCoordinates: Set<Coordinate> = []
        changedCoordinates.insert(coordinate)
        while let nextCoordinate = changedCoordinates.popFirst() {
            guard let destroyedTiles = checkForMatchingPhrase(at: nextCoordinate) else {
                continue
            }
            grid.removeTexts(at: destroyedTiles)
            currentScore += destroyedTiles.count

            let shiftedTiles = shiftDownTiles(destroyedTiles)
            destroyedAndShiftedTiles.append((destroyedTiles: destroyedTiles, shiftedTiles: shiftedTiles))
        }
        let hasLandedAtTopRow = (coordinate.row == Coordinate.origin.row)
        if hasLandedAtTopRow && destroyedAndShiftedTiles.isEmpty {
            gameStatus = .endedWithLost
        }
        return destroyedAndShiftedTiles
    }

    func landTile(from coordinate: Coordinate) -> Coordinate {
        for row in (coordinate.row + 1)..<grid.numRows {
            let coordinateToLand = Coordinate(row: row, col: coordinate.col)
            if tryLandTile(at: coordinateToLand) {
                return coordinateToLand
            }
        }
        fatalError("Failed to land tile")
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
        timer.startTimer(timerInterval: Constants.Game.Tetris.timeInterval)
    }
}
