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
        let tiles = phrases.flatMap { $0.chinese.characters.map { char in String(char) } }

        super.init(time: time, gameData: gameData, tiles: tiles,
                   rows: numberOfPhrases, columns: Constants.Game.Swapping.columns)

        gameTitle = Constants.Game.Swapping.ChengYu.gameTitle
        gameInstruction = Constants.Game.Swapping.ChengYu.gameInstruction
    }

    /// Returns if and only if the game is won, that is: every row is a valid Chengyu.
    override func lineIsCorrect(_ line: [Coordinate]) -> Bool {
        guard let text = gridData.getConcatenatedTexts(at: line),
              gameData.phrases.contains(chinese: text) else {
            return false
        }
        return true
    }
}
