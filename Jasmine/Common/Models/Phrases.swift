import RealmSwift

/// Phrases contains list of phrases for a particular difficulty
class Phrases {

    private var phrases: Results<Phrase>
    private var range: CountableRange<Int>
    private var shuffledRange: [Int] = []
    let phraseLength: Int

    init(_ phrases: Results<Phrase>, range: CountableRange<Int>, phraseLength: Int) {
        self.phrases = phrases
        self.range = range
        self.phraseLength = phraseLength
    }

    /// Returns a list of phrases
    ///
    /// - Parameter length: length of resulting array
    /// - Returns: An array of Phrase
    func next(count: Int) -> [Phrase] {
        return (0..<count).map { _ in
            self.next()
        }
    }

    /// Returns the next phrase, non-exhaustive
    ///
    /// - Returns: Phrase
    func next() -> Phrase {
        if shuffledRange.isEmpty {
            shuffledRange = self.range.shuffled()
        }
        let nextIndex = shuffledRange.removeFirst()
        return self.phrases[nextIndex]
    }

    /// Checks if the chinese text is a valid chinese phrase, regardless of position
    ///
    /// - Parameter chinese: chinese word to test for presence
    /// - Returns: true if there is such a word
    func contains(chinese: String) -> Bool {
        return phrases.filter("chinese == '\(chinese)'").count >= 1
    }

}
