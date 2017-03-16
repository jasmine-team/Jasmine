import Foundation
import Alamofire
import RealmSwift

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
    func parse(fileName: String,
               encoding: String.Encoding = .utf8,
               seperatedBy seperator: String = "\n") throws -> [String] {
        let fileExtension = "txt"
        guard let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) else {
            throw FileError.fileNotFound
        }
        let content = try String(contentsOf: url, encoding: encoding)
        return content.components(separatedBy: seperator)
    }

    func hydrate(listOfPhrases: [String]) -> [Phrase] {
        return listOfPhrases.enumerated().map { (i, phrase) in
            let valueDict = [
                "chinese": phrase,
                "english": "lol",
                "rank": "\(i)",
                "pinyin": "wut",
                "meaning": "what",
                ]
            return Phrase(value: valueDict)
        }
    }

    func hydrateRealm(with data: [Phrase]) {
        do {
            let realm = try Realm()
            realm.add(data)
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }

}
