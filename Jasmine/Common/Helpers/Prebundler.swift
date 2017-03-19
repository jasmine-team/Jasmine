import Foundation
import Alamofire
import RealmSwift
import PromiseKit

enum FileError: Error {
    case fileNotFound
}

/// Prebundler that collects data from multiple api locations
struct Prebundler {

    /// Limit of phrases to fetch at once
    fileprivate static let fetchLimit = 200
    /// Text file of list of phrases to read from
    fileprivate static let phrasesFileName = "phrases"
    /// Identifier for memory realm to prevent memory collisions, is arbitrary
    fileprivate static let memoryIdentifier = "prebundleRealm"
    /// Prebundled realm file name, must end in .realm extension
    fileprivate static let prebundledFileName = "prebundled.realm"

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
        guard let url = Bundle.main.url(forResource: fileName,
                                        withExtension: fileExtension) else {
            throw FileError.fileNotFound
        }
        let content = try String(contentsOf: url, encoding: encoding)
        return content.components(separatedBy: seperator)
    }

    /// Fetches from APIs to fill a phrase with necessary information
    /// May not always return information should it not exist in API
    ///
    /// - Parameters:
    ///   - phrase: the phrase to search for definitions
    ///   - rank: commonality rank of the phrase
    /// - Returns: a promise that returns a conditional phrase
    static func fetch(phrase: String, rank: Int) -> Promise<Phrase?> {
        print(phrase, rank)
        let definitions = [
            API.getDefinition(of: phrase, from: .chinese, to: .english),
            // Api.getDefinition(of: phrase),
        ]
        return when(fulfilled: definitions).then { results -> Phrase? in
            let englishDefinitionJSON = results[0]
            // let chineseDefinitionJSON = results[1]
            // print("chinese def", chineseDefinitionJSON)

            guard let englishResponse = try? EnglishApiResponse(json: englishDefinitionJSON) else {
                return nil
            }

            let valueDict: [String : Any] = [
                "chinese": phrase,
                "pinyin": "",
                "english": englishResponse.english,
                "englishMeaning": englishResponse.englishMeaning,
                "chineseMeaning": "",
                "rank": rank,
            ]
            return Phrase(value: valueDict)
        }.catch { error in
            fatalError("\(phrase): \(error.localizedDescription)")
        }
    }

    /// Reads from the phrases file and saves realm database into file system
    static func fillDatabase() {
        do {
            let listOfPhrases = try Prebundler.parse(fileName: "phrases")
            let promises = listOfPhrases.enumerated().prefix(fetchLimit).map { i, phrase in
                return Prebundler.fetch(phrase: phrase, rank: i)
            }
            when(fulfilled: promises).then { results -> Void in
                persistRealm(with: results.flatMap { $0 })  // filter nils
            }.catch { error in
                fatalError(error.localizedDescription)
            }
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }

    /// Replaces the prebundled realm file over to default realm
    static func hydrateRealm() {
        guard let resourceUrl = Bundle.main.resourceURL else {
            fatalError("Main bundle does not have a resource URL")
        }
        let prebundledUrl = resourceUrl.appendingPathComponent(Prebundler.prebundledFileName)
        do {
            try FileManager.default.copyItem(at: prebundledUrl, to: Realm.defaultURL)
        } catch let error {
            fatalError("Error: \(error.localizedDescription)")
        }
    }

    /// Does the necessary steps to save a realm database into file system
    /// See: https://realm.io/docs/swift/latest/#bundling-a-realm-with-an-app
    ///
    /// - Parameter data: list of phrases to save
    static func persistRealm(with data: [Phrase]) {
        do {
            // use in-memory realm to prevent old data
            let config = Realm.Configuration(inMemoryIdentifier: Prebundler.memoryIdentifier)
            let realm = try Realm(configuration: config)

            try realm.write {
                realm.add(data)
            }

            let bundledUrl = Realm.defaultURL
                .deletingLastPathComponent()
                .appendingPathComponent(Prebundler.prebundledFileName)

            // compress and save to file
            try realm.writeCopy(toFile: bundledUrl)
            print("bundled file saved to \(bundledUrl)")
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }

}
