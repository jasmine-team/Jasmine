import Foundation
import Alamofire
import RealmSwift
import PromiseKit

enum FileError: Error {
    case fileNotFound
}

struct Scrapper {

    /// Parses a text file with each item seperated by a seoerator
    ///
    /// - Parameters:
    ///   - fileName: file name as defined in the repository
    ///   - encoding: file encoding format, defaults to utf8
    ///   - seperator: word seperator, defaults to newline
    /// - Returns: Array of string
    /// - Throws: File not found error or string parsing error
    static func parse(fileName: String, encoding: String.Encoding = .utf8,
                      seperatedBy seperator: String = "\r\n") throws -> [String] {
        let fileExtension = "txt"
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            throw FileError.fileNotFound
        }
        let content = try String(contentsOf: url, encoding: encoding)
        return content.components(separatedBy: seperator)
    }

    static func fetch(phrase: String, rank: Int) -> Promise<Phrase> {
        print(phrase, rank)
        return Api.getDefinition(of: phrase, from: .chinese, to: .english).then { jsonDict -> Phrase in
            guard let answers = jsonDict["tuc"] as? [Any] else {
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

            let valueDict: [String : Any] = [
                "chinese": phrase,
                "pinyin": "",
                "english": english,
                "englishMeaning": englishMeaning,
                "chineseMeaning": "",
                "rank": rank,
            ]
            return Phrase(value: valueDict)
        }.catch { error in
            fatalError("\(phrase): \(error.localizedDescription)")
        }
    }

    static func fillDatabase() {
        do {
            let listOfPhrases = try Scrapper.parse(fileName: "phrases")
            let promises = listOfPhrases.enumerated().suffix(10).dropLast(1).map { i, phrase in
                return Scrapper.fetch(phrase: phrase, rank: i)
            }
            when(fulfilled: promises).then { results in
                hydrateRealm(with: results)
            }.catch { error in
                fatalError(error.localizedDescription)
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }

    static func hydrateRealm(with data: [Phrase]) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(data)
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }

}
