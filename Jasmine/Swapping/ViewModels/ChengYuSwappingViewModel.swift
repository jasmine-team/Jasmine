import Foundation

class ChengYuSwappingViewModel: BaseSwappingViewModel {
    /// Initializes the game
    ///
    /// - Parameters:
    ///   - time: initial time
    ///   - gameData: game data
    ///   - numberOfPhrases: number of phrases to be produced
    init(time: TimeInterval, gameData: GameData, numberOfPhrases: Int) {
        let phrases = gameData.phrases.next(count: numberOfPhrases)
        let tiles = phrases.flatMap { $0.chinese }
        super.init(time: time, gameData: gameData, tiles: tiles,
                   rows: numberOfPhrases, columns: GameConstants.Swapping.columns)

        gameTitle = GameConstants.Swapping.ChengYu.gameTitle
        gameInstruction = GameConstants.Swapping.ChengYu.gameInstruction

        phrasesTested = Set(phrases)
    }

    /// Returns if and only if the game is won, that is: every row is a valid Chengyu.
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
    override func swapTiles(_ coord1: Coordinate, and coord2: Coordinate) -> Bool {
        let swapResult = super.swapTiles(coord1, and: coord2)
        if swapResult {
            checkCorrectTiles()
        }
        return swapResult
    }
}
