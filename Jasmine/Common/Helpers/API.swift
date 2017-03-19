import Alamofire
import PromiseKit

enum JSONParsingError: Error {
    case invalidDictionary, invalidArray, invalidString
}

struct API: APIProtocol {

    /// URL to translate words between English and Chinese
    fileprivate static let translateApiUrl = "https://glosbe.com/gapi/translate"
    /// URL to translate words from Chinese to English
    fileprivate static let chineseDictApiUrl = "https://api.jisuapi.com/cidian/word"
    /// URL to translate Chinese idiom (cheng yu) words
    fileprivate static let chineseIdiomsApiUrl = "https://v.juhe.cn/chengyu/query"

    /// Translates from one language to another
    ///
    /// - Parameters:
    ///   - phrase: phrase to be translated
    ///   - sourceLang: source language to be converted from
    ///   - destLang: destination language to be converted to
    /// - Returns: Promise of destination language definition in JSON
    static func getDefinition(of phrase: String,
                              from sourceLang: Constants.Language,
                              to destLang: Constants.Language) -> Promise<[String: Any]> {
        let parameters: Parameters = [
            "from": sourceLang.rawValue,
            "dest": destLang.rawValue,
            "format": "json",
            "phrase": phrase,
        ]
        // All three of these calls are equivalent
        return getJSON(fromUrl: translateApiUrl, parameters: parameters)
    }

    /// Gets the definition from JSON api end point
    ///
    /// - Parameter phrase: Chinese phrase
    /// - Returns: Promise of Chinese definition in JSON
    static func getDefinition(of phrase: String) -> Promise<[String: Any]> {
        let parameters: Parameters = [
            "appkey": Secrets.ApiKeys.chineseDict,
            "word": phrase,
        ]
        return getJSON(fromUrl: chineseDictApiUrl, parameters: parameters)
    }

    /// Gets the english definition from JSON api end point
    ///
    /// - Parameter phrase: Chinese idiom
    /// - Returns: Promise of Chinese definition in JSON
    static func getChineseIdiomDefinition(fromIdiom phrase: String) -> Promise<[String: Any]> {
        let parameters: Parameters = [
            "key": Secrets.ApiKeys.chineseIdiom,
            "word": phrase,
        ]
        return getJSON(fromUrl: chineseIdiomsApiUrl, parameters: parameters)
    }

    /// Fetch JSON from APIs
    ///
    /// - Parameters:
    ///   - urlString: base url to fetch from
    ///   - parameters: parameters to be URL encoded and sent
    /// - Returns: A promise wrapped around JSON
    fileprivate static func getJSON(fromUrl urlString: String,
                                    parameters: Parameters) -> Promise<[String: Any]> {
        return Promise { fulfill, reject in
            Alamofire.request(urlString, parameters: parameters)
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
