import RealmSwift

/// Phrase model to store strings of various languages, read-only, can contain more than one word
class Phrase: Object {

    /// Information should be read only during operation
    dynamic fileprivate(set) var chinese: String = ""
    dynamic fileprivate(set) var pinyin: String = ""
    dynamic fileprivate(set) var english: String = ""

    /// Meaning of the word in english
    dynamic fileprivate(set) var meaning: String = ""

    /// Complexity of the word in practice, higher means more difficult
    dynamic fileprivate(set) var complexity: Float = 0

}
