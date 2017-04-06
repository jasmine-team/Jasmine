import Foundation

class ChengYuSlidingViewModel: BaseSlidingViewModel {
    /// Initializes the game
    ///
    /// - Parameters:
    ///   - time: initial time
    ///   - gameData: game data
    ///   - rows: rows in the game
    init(time: TimeInterval, gameData: GameData, rows: Int) {
        let phrases = gameData.phrases.next(count: rows)
        let tiles = phrases.flatMap { $0.chinese.characters.map { char in String(char) } }
        let tilesExceptLast = tiles.enumerated().map { (idx, tile) in
            (idx == tiles.count - 1) ? nil : tile
        }

        super.init(time: time, gameData: gameData, tiles: tilesExceptLast,
                   rows: rows, columns: Constants.Game.Sliding.columns)

        gameTitle = Constants.Game.Sliding.ChengYu.gameTitle
        gameInstruction = Constants.Game.Sliding.ChengYu.gameInstruction

        var validPhrases = phrases
        validPhrases.removeLast()
        phrasesTested = Set(validPhrases)
    }

    /// Returns true if and only if the given line is valid (i.e. forms a Chengyu)
    override func lineIsCorrect(_ line: [Coordinate]) -> Bool {
        guard let text = gridData.getConcatenatedTexts(at: line),
              gameData.phrases.contains(chinese: text) else {
            return false
        }
        return true
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
    override func slideTile(from start: Coordinate, to end: Coordinate) -> Bool {
        let slideResult = super.slideTile(from: start, to: end)
        if slideResult {
            checkCorrectTiles()
        }
        return slideResult
    }
}
