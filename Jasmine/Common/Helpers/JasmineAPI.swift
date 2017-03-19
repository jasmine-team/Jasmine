import Alamofire
import PromiseKit

struct JasmineAPI: APIProtocol {

    /// URL to translate words between English and Chinese
    fileprivate static let translateAPIUrl = "https://glosbe.com/gapi/translate"
    /// URL to get Chinese definitions
    fileprivate static let chineseDictAPIUrl = "https://api.jisuapi.com/cidian/word"
    /// URL to get Chinese idiom (cheng yu) definitions
    fileprivate static let chengYuAPIUrl = "https://v.juhe.cn/chengyu/query"

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
        return getJSON(fromUrl: translateAPIUrl, parameters: parameters)
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
        return getJSON(fromUrl: chineseDictAPIUrl, parameters: parameters)
    }

    /// Gets the chinese definition from JSON api end point
    ///
    /// - Parameter phrase: Chinese idiom (Cheng Yu)
    /// - Returns: Promise of Chinese definition in JSON
    static func getChengYuDefinition(of phrase: String) -> Promise<[String: Any]> {
        let parameters: Parameters = [
            "key": Secrets.ApiKeys.chengYu,
            "word": phrase,
        ]
        return getJSON(fromUrl: chengYuAPIUrl, parameters: parameters)
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
