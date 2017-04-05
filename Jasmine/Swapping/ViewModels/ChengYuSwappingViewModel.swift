import Foundation

class ChengYuSwappingViewModel: BaseSwappingViewModel {
    typealias Score = Constants.Game.Swapping.Score

    /// Initializes the game
    ///
    /// - Parameters:
    ///   - time: initial time
    ///   - gameData: game data
    ///   - numberOfPhrases: number of phrases to be produced
    init(time: TimeInterval, gameData: GameData, numberOfPhrases: Int) {
        let phrases = gameData.phrases.next(count: numberOfPhrases)
        let tiles = phrases.flatMap { $0.chinese.characters.map { char in String(char) } }

        super.init(time: time, gameData: gameData, tiles: tiles,
                   rows: numberOfPhrases, columns: Constants.Game.Swapping.columns)

        phrasesTested = phrases
        gameTitle = Constants.Game.Swapping.ChengYu.gameTitle
        gameInstruction = Constants.Game.Swapping.ChengYu.gameInstruction
    }

    /// Returns if and only if the game is won, that is: every row is a valid Chengyu.
    private func lineIsCorrect(_ line: [Coordinate]) -> Bool {
        guard let text = gridData.getConcatenatedTexts(at: line),
              gameData.phrases.contains(chinese: text) else {
            return false
        }
        return true
    }

    /// Check what happens when game is won. If game is won, change game status and add score.
    private func checkCorrectTiles() {
        var highlightedCoordinates: Set<Coordinate> = []
        var score = 0

        for row in 0..<gridData.numRows {
            let rowTiles = (0..<gridData.numColumns).map { column in Coordinate(row: row, col: column) }
            if lineIsCorrect(rowTiles) {
                highlightedCoordinates.formUnion(rowTiles)
                score += Score.line
            }
        }
        for column in 0..<gridData.numColumns {
            let columnTiles = (0..<gridData.numRows).map { row in Coordinate(row: row, col: column) }
            if lineIsCorrect(columnTiles) {
                highlightedCoordinates.formUnion(columnTiles)
                score += Score.line
            }
        }

        if self.highlightedCoordinates != highlightedCoordinates {
            self.highlightedCoordinates = highlightedCoordinates
        }

        if highlightedCoordinates.count == gridData.count {
            gameStatus = .endedWithWon
            score += max(Score.win + Int(timeRemaining * Score.multiplierFromTime) -
                moves * Score.multiplierFromMoves, 0)
        }

        currentScore = score
    }

    /// Tells the Game Engine View Model that the user from the View Controller attempts to slide
    /// the tile.
    ///
    /// Note that if the tiles are slided, `delegate.updateGridData()` should be called to update
    /// the grid data of the cell stored in the view controller. However, there is no need to call
    /// `delegate.redisplayAllTiles` as it will be done implicitly by the view controller when
    /// the sliding is successful (determined by the returned value).
    ///
    /// - Parameters:
    ///   - start: The tile to be slided.
    ///   - end: The destination of the sliding tile. Should be empty.
    /// - Returns: Returns true if the tile successfully slided, false otherwise.
    @discardableResult
    override func swapTiles(_ coord1: Coordinate, and coord2: Coordinate) -> Bool {
        let swapResult = super.swapTiles(coord1, and: coord2)
        if swapResult {
            checkCorrectTiles()
        }
        return swapResult
    }
}
