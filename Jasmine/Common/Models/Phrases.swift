import RealmSwift

/// Phrases contains list of phrases for a particular difficulty
class Phrases: Sequence, IteratorProtocol {

    static let all: Phrases = Phrases(List(allRawPhrases))

    private static let allRawPhrases: Results<Phrase> = {
        do {
            return try Realm().objects(Phrase.self)
        } catch {
            fatalError(error.localizedDescription)
        }
    }()

    func next() -> Phrase? {
        if range.isEmpty {
            range = Array(0..<phrases.count)
        }
        let nextIndex = range.removeFirst()
        return self.phrases[nextIndex]
    }

    private var phrases: List<Phrase>
    private var range: [Int] = []
    let phraseLength: Int

    /// Creates an encapsulated list of phrases for usage outside of models 
    ///
    /// - Parameters:
    ///   - phrases: realm list of phrases
    init(realm: Realm? = nil, _ phrases: List<Phrase>) {
        self.phrases = phrases
        guard let firstPhrase = phrases.first else {
            fatalError("Phrases is empty")
        }
        self.phraseLength = firstPhrase.chinese.count
    }

    /// Creates a copy of the phrase
    ///
    /// - Parameters:
    ///   - phrases: original phrases object
    ///   - isShuffled: option to change between shuffled, unshuffled versions
    convenience init(_ phrases: Phrases) {
        self.init(phrases.phrases)
    }

    /// Checks if the chinese text is a valid chinese phrase, must be exact match
    ///
    /// - Parameter chinese: chinese word to test for presence
    /// - Returns: true if there is such a word
    func contains(chinese: String) -> Bool {
        return filter(chinese: chinese).count >= 1
    }

    /// Checks if the chinese text array is a valid chinese phrase, must be exact match
    ///
    /// - Parameter chinese: chinese array to test for presence
    /// - Returns: true if there is such a word
    func contains(chineseArr: [String]) -> Bool {
        return contains(chinese: chineseArr.joined())
    }

    /// Returns valid phrase if chinese is in the database 
    ///
    /// - Parameter whereChinese: chinese word to look for
    /// - Returns: phrase if there's such a word and nil if not
    func first(whereChinese chinese: String) -> Phrase? {
        return filter(chinese: chinese).first
    }

    /// Returns the phrases count
    var count: Int {
        return phrases.count
    }

    /// MARK: Helper functions

    /// Creates a predicate that filters based on character count
    ///
    /// - Parameter count: numebr of characters for the chinese phrase
    /// - Returns: a string that follows NSPredicate format
    private var chineseLengthPredicate: String {
        return "rawChinese LIKE '\(String(repeating: "?", count: phraseLength))'"
    }

    /// Returns result after applying result predicate to realm db
    /// Note: Will only result 0 or 1 result since chinese is guaranteed to be unique
    ///
    /// - Parameter chinese: chinese word
    /// - Returns: result of phrase
    private func filter(chinese: String) -> Results<Phrase> {
        return Phrases.allRawPhrases.filter("rawChinese == '\(chinese)'")
    }

}
