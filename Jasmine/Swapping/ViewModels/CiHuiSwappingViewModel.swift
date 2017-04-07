import Foundation

class CiHuiSwappingViewModel: BaseSwappingViewModel {
    /// Initializes the game
    ///
    /// - Parameters:
    ///   - time: initial time
    ///   - gameData: game data
    ///   - numberOfPhrases: number of phrases to be produced
    init(time: TimeInterval, gameData: GameData, numberOfPhrases: Int) {
        let phrases = gameData.phrases.next(count: numberOfPhrases)

        var tiles: [String] = []
        for phrase in phrases {
            let hanzi = phrase.chinese
            let pinyin = phrase.pinyin

            tiles += (hanzi + pinyin)
        }

        super.init(time: time, gameData: gameData, tiles: tiles,
                   rows: numberOfPhrases, columns: GameConstants.Swapping.columns)

        gameTitle = GameConstants.Swapping.CiHui.gameTitle
        gameInstruction = GameConstants.Swapping.CiHui.gameInstruction

        phrasesTested = Set(phrases)
    }

    /// Returns if and only if the game is won, that is:
    /// every row/column contains the cihui and the respective pinyin.
    override func lineIsCorrect(_ line: [Coordinate]) -> Bool {
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
