import Alamofire
import PromiseKit

enum JSONParsingError: Error {
    case invalidDictionary, invalidArray, invalidString
}

struct Api: ApiProtocol {

    fileprivate static let translateApiUrl = "https://glosbe.com/gapi/translate"
    fileprivate static let chineseDictApiUrl = "http://api.jisuapi.com/cidian/word"
    fileprivate static let chineseIdiomsApiUrl = "http://v.juhe.cn/chengyu/query"

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
        let request = Alamofire.request(translateApiUrl, parameters: parameters)
        print(phrase, request, destLang)
        // All three of these calls are equivalent
        return getJson(fromUrl: translateApiUrl, parameters: parameters)
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
        return getJson(fromUrl: chineseDictApiUrl, parameters: parameters)
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
        return getJson(fromUrl: chineseIdiomsApiUrl, parameters: parameters)
    }

    fileprivate static func getJson(fromUrl urlString: String,
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
