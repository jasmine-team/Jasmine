protocol GameStatisticsProtocol: CountdownTimable {
    // MARK: Game Properties
    /// Specifies the current score of the game. If the game has not started, it will be the initial
    /// displayed score.
    var currentScore: Int { get }

    /// Provide a brief title for this game. Note that this title should be able to fit within the
    /// width of the display.
    var gameTitle: String { get }

    /// Provide of a brief description of its objectives and how this game is played. 
    /// There is no word count limit, but should be concise.
    var gameInstruction: String { get }

    // MARK: Game Actions
    /// The status of the current game.
    var gameStatus: GameStatus { get }
}
