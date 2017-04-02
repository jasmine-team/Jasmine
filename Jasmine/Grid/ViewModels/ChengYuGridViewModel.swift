import Foundation

class ChengYuGridViewModel: BaseGridViewModel {
    /// The game data of this game.
    let gameData: GameData

    /// Initializes the game
    ///
    /// - Parameters:
    ///   - time: initial time
    ///   - gameData: game data
    ///   - numberOfPhrases: number of phrases to be produced
    init(time: TimeInterval, gameData: GameData, numberOfPhrases: Int) {
        self.gameData = gameData
        let phrases = gameData.phrases.next(count: numberOfPhrases)
        let tiles = phrases.flatMap { $0.chinese.characters.map { char in String(char) } }

        super.init(time: time, tiles: tiles, rows: numberOfPhrases, columns: Constants.Game.Grid.columns)

        gameTitle = Constants.Game.Grid.ChengYu.gameTitle
        gameInstruction = Constants.Game.Grid.ChengYu.gameInstruction
    }

    /// Returns if and only if the game is won, that is: every row is a valid Chengyu.
    override var hasGameWon: Bool {
        for row in 0..<gridData.numRows {
            var text = ""

            for col in 0..<gridData.numColumns {
                guard let tile = gridData[Coordinate(row: row, col: col)] else {
                    return false
                }
                text += tile
            }

            if !gameData.phrases.contains(chinese: text) {
                return false
            }
        }

        return true
    }
}
