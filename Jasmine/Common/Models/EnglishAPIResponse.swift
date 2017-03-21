struct EnglishAPIResponse {

    let english: String
    let englishMeaning: String

    init(json: [String: Any]) throws {
        guard let answers = json["tuc"] as? [Any] else {
            throw JSONParsingError.invalidArray
        }
        guard let answer = answers.first as? [String: Any],
            let definition = answer["phrase"] as? [String: Any],
            let rawMeanings = answer["meanings"] as? [Any] else {
                throw JSONParsingError.invalidDictionary
        }
        let meanings = try rawMeanings.map { rawMeaning -> [String: Any] in
            guard let meaning = rawMeaning as? [String: Any] else {
                throw JSONParsingError.invalidDictionary
            }
            return meaning
        }
        guard let meaning = try meanings.first(where: { meaning in
            guard let language = meaning["language"] as? String else {
                throw JSONParsingError.invalidString
            }
            return language == "en"
        }) else {
            throw JSONParsingError.invalidArray
        }
        guard let englishMeaning = meaning["text"] as? String,
            let english = definition["text"] as? String else {
                throw JSONParsingError.invalidString
        }
        self.english = english
        self.englishMeaning = englishMeaning
    }

}
