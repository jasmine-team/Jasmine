import PromiseKit

/// Protocol to obtain translation and definitions from APIs
protocol ApiProtocol {

    /// Translates from one language to another
    ///
    /// - Parameters:
    ///   - phrase: phrase to be translated
    ///   - sourceLang: source language to be converted from
    ///   - destLang: destination language to be converted to
    /// - Returns: destination language definition in JSON
    static func getDefinition(of phrase: String,
                              from sourceLang: Constants.Language,
                              to destLang: Constants.Language) -> Promise<[String: Any]>

    /// Gets the definition from JSON api end point
    ///
    /// - Parameter phrase: Chinese phrase
    /// - Returns: English definition in JSON
    static func getDefinition(of phrase: String) -> Promise<[String: Any]>

    /// Gets the english definition from JSON api end point
    ///
    /// - Parameter phrase: Chinese idiom
    /// - Returns: Chinese definition in JSON
    static func getChineseIdiomDefinition(fromIdiom phrase: String) -> Promise<[String: Any]>

}
