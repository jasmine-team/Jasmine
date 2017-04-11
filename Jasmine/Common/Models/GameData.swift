/// Simple container for information necessary for every game, to be returned to GameManager
struct GameData {

    /// MARK: Information for creation of game
    let name: String
    /// Pool of Phrases to draw questions from 
    let phrases: Phrases
    let difficulty: Int

    init(name: String, phrases: Phrases, difficulty: Int) {
        self.name = name
        self.phrases = phrases
        self.difficulty = difficulty
    }

    /// MARK: Information for outcome of game
    var score: Int = 0

    /// result of game
    var gameStatus: GameStatus = .notStarted

    /// Set of phrases tested in the game
    var phrasesTested: Set<Phrase> = []

}
