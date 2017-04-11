import RealmSwift

/// Phrases contains list of phrases for a particular difficulty
class Phrases {

    private lazy var allRawPhrases: Results<Phrase> = {
        if let realm = self.phrases.first?.realm {
            return realm.objects(Phrase.self)
        }
        do {
            return try Realm().objects(Phrase.self)
        } catch {
            fatalError(error.localizedDescription)
        }
    }()

    fileprivate var phrases: List<Phrase>
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
        return allRawPhrases.filter("rawChinese == '\(chinese)'")
    }

}

extension Phrases: Collection {

    var startIndex: Int {
        return 0
    }

    var endIndex: Int {
        return phrases.count
    }

    /// Returns the phrases count
    var count: Int {
        return phrases.count
    }

    func index(after: Int) -> Int {
        return after + 1
    }

    subscript(position: Int) -> Phrase {
        return self.phrases[position]
    }

}
