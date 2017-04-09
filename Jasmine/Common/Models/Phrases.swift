import RealmSwift

/// Phrases contains list of phrases for a particular difficulty
class Phrases {

    private lazy var allPhrases: AnyRealmCollection<Phrase> = {
        do {
            let realm = try Realm()
            let results = realm.objects(Phrase.self).filter(self.chineseLengthPredicate)
            return AnyRealmCollection(results)
        } catch {
            assertionFailure(error.localizedDescription +
                "Failed to instantiate" +
                "Did you call phrases through Level or PlayerManager?")
        }
        return AnyRealmCollection(self.phrases)
    }()

    private var phrases: List<Phrase>
    private var range: [Int] = []
    var isShuffled: Bool
    let phraseLength: Int

    /// Creates an encapsulated list of phrases for usage outside of models 
    ///
    /// - Parameters:
    ///   - phrases: realm list of phrases
    ///   - isShuffled: whether retrieval of this list should be shuffled
    init(_ phrases: List<Phrase>, isShuffled: Bool = false) {
        self.phrases = phrases
        guard let firstPhrase = phrases.first else {
            fatalError("Phrases is empty")
        }
        self.phraseLength = firstPhrase.chinese.count
        self.isShuffled = isShuffled
    }

    /// Creates a copy of the phrase
    ///
    /// - Parameters:
    ///   - phrases: original phrases object
    ///   - isShuffled: option to change between shuffled, unshuffled versions
    convenience init(_ phrases: Phrases, isShuffled: Bool = false) {
        self.init(phrases.phrases, isShuffled: isShuffled)
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

    /// Returns the next phrase, non-exhaustively.
    ///
    /// - Returns: Phrase
    func next() -> Phrase {
        if range.isEmpty {
            range = Array(0..<phrases.count)
        }
        if isShuffled {
            range.shuffle()
        }
        let nextIndex = range.removeFirst()
        return self.phrases[nextIndex]
    }

    /// Converts underlying collection to an array.
    /// NOTE: This process is inefficient, i.e. don't use this unless you need to
    ///
    /// - Returns: Array of phrase
    func toArray() -> [Phrase] {
        return Array(phrases)
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

    /// Returns a valid phrase, rolls over if out of bounds
    ///
    /// - Parameter index: index of the phrase
    subscript(index: Int) -> Phrase {
        return phrases[index % phrases.count]
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
        return allPhrases.filter("rawChinese == '\(chinese)'")
    }

}
