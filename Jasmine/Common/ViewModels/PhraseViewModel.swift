import AVFoundation

/// The VM for the (detailed) phrase view controller.
class PhraseViewModel {
    /// Phrase object contained in this VM
    private let phrase: Phrase

    /// The Han Zi shown for the view
    var hanZi: String {
        return phrase.chinese.joined()
    }

    /// The Pin Yin shown for the view
    var pinYin: String {
        return phrase.pinyin.joined(separator: " ")
    }

    /// The English shown for the view
    var english: String {
        return phrase.english
    }

    /// The speech object for the text-to-speech
    var speech: AVSpeechUtterance {
        let speech = AVSpeechUtterance(string: hanZi)
        speech.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        return speech
    }

    /// Initializes this VM with a given Phrase
    ///
    /// - Parameter phrase: the phrase
    init(phrase: Phrase) {
        self.phrase = phrase
    }
}
