class PhraseViewModel {
    private let phrase: Phrase

    var hanZi: String {
        return phrase.chinese.joined()
    }

    var pinYin: String {
        return phrase.pinyin.joined(separator: " ")
    }

    var english: String {
        return phrase.english
    }

    init(phrase: Phrase) {
        self.phrase = phrase
    }
}
