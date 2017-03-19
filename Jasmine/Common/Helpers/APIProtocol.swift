import PromiseKit

/// Protocol to obtain translation and definitions from APIs
protocol APIProtocol {

    /// Translates from one language to another
    ///
    /// - Parameters:
    ///   - phrase: phrase to be translated
    ///   - sourceLang: source language to be converted from
    ///   - destLang: destination language to be converted to
    /// - Returns: Promise of destination language definition in JSON
    static func getDefinition(of phrase: String,
                              from sourceLang: Constants.Language,
                              to destLang: Constants.Language) -> Promise<[String: Any]>

    /// Gets the definition from JSON api end point
    ///
    /// - Parameter phrase: Chinese phrase
    /// - Returns: Promise of Chinese definition in JSON
    static func getDefinition(of phrase: String) -> Promise<[String: Any]>

    /// Gets the english definition from JSON api end point
    ///
    /// - Parameter phrase: Chinese idiom
    /// - Returns: Promise of Chinese definition in JSON
    static func getChineseIdiomDefinition(fromIdiom phrase: String) -> Promise<[String: Any]>

}
