import RealmSwift

/// Phrase model to store strings of various languages, read-only except for timeSeen
class Phrase: Object {

    private static let rawPinyinDelimiter = " "
    
    /// Rank of the frequency of word in practice, higher means more difficult
    // -1 for invalid rank, realm doesn't support init without defaults
    private dynamic var rank: Int = -1

    /// Information should be read only during operation
    private dynamic var rawChinese: String = ""
    private dynamic var rawPinyin: String = ""
    private(set) dynamic var english: String = ""

    // Meaning of the word in english / chinese
    private(set) dynamic var englishMeaning: String = ""
    private(set) dynamic var chineseMeaning: String = ""
    
    // Example usage of the word in chinese
    private(set) dynamic var chineseExample: String = ""

    override static func primaryKey() -> String? {
        return "rawChinese"
    }

    /// MARK: non-persisted properties
    var chinese: [String] {
        return rawChinese.characters.map {
            String($0)
        }
    }
    var pinyin: [String] {
        return rawPinyin.components(separatedBy: Phrase.rawPinyinDelimiter)
    }

    override static func ignoredProperties() -> [String] {
        return ["chinese", "pinyin"]
    }

}
