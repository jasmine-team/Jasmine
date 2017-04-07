import AVFoundation

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

    var speech: AVSpeechUtterance {
        let speech = AVSpeechUtterance(string: hanZi)
        speech.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        return speech
    }

    init(phrase: Phrase) {
        self.phrase = phrase
    }
}
