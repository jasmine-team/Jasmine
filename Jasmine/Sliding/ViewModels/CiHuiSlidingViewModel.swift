import Foundation

class CiHuiSlidingViewModel: BaseSlidingViewModel {
    /// Initializes the game
    ///
    /// - Parameters:
    ///   - time: initial time
    ///   - gameData: game data
    ///   - rows: rows in the game
    init(time: TimeInterval, gameData: GameData, rows: Int) {
        let phrases = gameData.phrases.next(count: rows)

        var tiles: [String] = []
        for phrase in phrases {
            let hanzi = phrase.chinese
            let pinyin = phrase.pinyin

            tiles += (hanzi + pinyin)
        }
        let tilesExceptLast = tiles.enumerated().map { (idx, tile) in
            (idx == tiles.count - 1) ? nil : tile
        }

        super.init(time: time, gameData: gameData, tiles: tilesExceptLast,
                   rows: rows, columns: Constants.Game.Sliding.columns)

        gameTitle = Constants.Game.Sliding.CiHui.gameTitle
        gameInstruction = Constants.Game.Sliding.CiHui.gameInstruction

        var validPhrases = phrases
        validPhrases.removeLast()
        phrasesTested = Set(validPhrases)
    }

    /// Returns true if and only if the given line is valid (i.e. forms a Hanzi with its Pinyin)
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
    override func slideTile(from start: Coordinate, to end: Coordinate) -> Bool {
        let slideResult = super.slideTile(from: start, to: end)
        if slideResult {
            checkCorrectTiles()
        }
        return slideResult
    }
}
