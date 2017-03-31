import RealmSwift

/// Phrases contains list of phrases for a particular difficulty
class Phrases: Sequence {

    private var phrases: Results<Phrase>
    private var range: CountableRange<Int>

    init(_ phrases: Results<Phrase>, range: CountableRange<Int>) {
        self.phrases = phrases
        self.range = range
    }

    /// Makes an infinite generator of phrases, repeats phrases when exhausted
    ///
    /// - Returns: Iterator of phrases
    func makeIterator() -> AnyIterator<Phrase> {
        var shuffledRange: [Int] = []
        return AnyIterator {
            if shuffledRange.isEmpty {
                shuffledRange = self.range.shuffled()
            }
            let nextIndex = shuffledRange.removeFirst()
            return self.phrases[nextIndex]
        }
    }

    /// Checks if the chinese text is a valid chinese phrase, regardless of position
    ///
    /// - Parameter chinese: chinese word to test for presence
    /// - Returns: true if there is such a word
    func contains(chinese: String) -> Bool {
        return phrases.filter("chinese == '\(chinese)'").count >= 1
    }

}
