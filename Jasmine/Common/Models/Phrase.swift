import RealmSwift

/// Phrase model to store strings of various languages, read-only except for timeSeen
class Phrase: Object {

    /// Rank of the frequency of word in practice, higher means more difficult
    // -1 for invalid rank, realm doesn't support init without defaults
    private dynamic var rank: Int = -1

    /// Information should be read only during operation
    private dynamic var rawChinese: String = ""
    private dynamic var rawPinyin: String = ""
    private(set) dynamic var english: String = ""

    /// Meaning of the word in english
    private(set) dynamic var englishMeaning: String = ""
    private(set) dynamic var chineseMeaning: String = ""

    override static func primaryKey() -> String? {
        return "rawChinese"
    }

    /// MARK: ignoredProperties
    var chinese: [String] {
        return rawChinese.components(separatedBy: "")
    }
    var pinyin: [String] {
        return rawPinyin.components(separatedBy: " ")
    }

    override static func ignoredProperties() -> [String] {
        return ["chinese", "pinyin"]
    }

}
