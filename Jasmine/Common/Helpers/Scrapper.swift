import Foundation
import Alamofire
import RealmSwift

struct Scrapper {
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        guard let documentsDirectory = paths.first else {
            fatalError("Could not find any directory")
        }
        return documentsDirectory
    }

    func parse(fileName: String) -> [String] {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "txt") else {
            fatalError("Could not find file")
        }
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            return content.components(separatedBy: "\t")
        } catch {
            fatalError(error as? String ?? "Could not cast error to string")
        }
    }

    func parse(fileContent: String) {
        let realm = try! Realm()
        let phrases = fileContent.components(separatedBy: "\t")
        for (i, ciHui) in phrases.enumerated() {
            let valueDict = [
                "chinese": ciHui,
                "english": "lol",
                "rank": "\(i)",
                "pinyin": "wut",
                "meaning": "what",
                ]
            let phrase = Phrase(value: valueDict)
            do {
                try realm.write {
                    realm.add(phrase)
                }
            } catch {
                fatalError(error as? String ?? "Could not cast error to string")
            }
        }
    }
}
