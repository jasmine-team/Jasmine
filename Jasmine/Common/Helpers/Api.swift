import Alamofire
import PromiseKit

enum JSONParsingError: Error {
    case invalidDictionary
}

struct Api: ApiProtocol {

    fileprivate let chineseDictApiUrl = ""
    fileprivate let englishDictApiUrl = ""
    fileprivate let chineseIdiomsApiUrl = ""

    /// Gets the english definition from JSON api end point
    ///
    /// - Parameter phrase: Chinese phrase
    /// - Returns: English definition in JSON
    func getEnglishDefinition(fromChinese phrase: String) -> Promise<[String: Any]> {
        let query = chineseDictApiUrl + Secrets.ApiKeys.chineseDict + phrase
        return getJson(fromUrl: query)
    }

    /// Gets the chinese definition from JSON api end point
    ///
    /// - Parameter phrase: Chinese phrase
    /// - Returns: Chinese definition in JSON
    func getChineseDefinition(fromEnglish phrase: String) -> Promise<[String: Any]> {
        let query = englishDictApiUrl + Secrets.ApiKeys.englishDict + phrase
        return getJson(fromUrl: query)
    }

    /// Gets the english definition from JSON api end point
    ///
    /// - Parameter phrase: Chinese idiom
    /// - Returns: Chinese definition in JSON
    func getChineseIdiomDefinition(fromIdiom phrase: String) -> Promise<[String: Any]> {
        let query = chineseIdiomsApiUrl + Secrets.ApiKeys.chineseIdiom + phrase
        return getJson(fromUrl: query)
    }

    fileprivate func getJson(fromUrl urlString: String) -> Promise<[String: Any]> {
        return Promise { fulfill, reject in
            Alamofire.request(urlString)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let json):
                        guard let dictionary = json as? [String: Any] else {
                            reject(JSONParsingError.invalidDictionary)
                            return
                        }
                        fulfill(dictionary)
                    case .failure(let error):
                        reject(error)
                    }
                }
        }
    }

}
