import RealmSwift

/// Phrase model to store strings of various languages, read-only, can contain more than one word
class Phrase: Object {

    /// Information should be read only during operation
    dynamic fileprivate(set) var chinese: String = ""
    dynamic fileprivate(set) var pinyin: String = ""
    dynamic fileprivate(set) var english: String = ""

    /// Meaning of the word in english
    dynamic fileprivate(set) var englishMeaning: String = ""
    dynamic fileprivate(set) var chineseMeaning: String = ""

    /// Rank of the frequency of word in practice, higher means more difficult
    // -1 for invalid rank, realm doesn't support init without defaults
    dynamic fileprivate(set) var rank: Int = -1

}
