import PromiseKit

/// Protocol to obtain translation and definitions from APIs
protocol ApiProtocol {

    /// Gets the english definition from JSON api end point
    ///
    /// - Parameter phrase: Chinese phrase
    /// - Returns: English definition in JSON
    func getEnglishDefinition(fromChinese phrase: String) -> Promise<[String: Any]>

    /// Gets the chinese definition from JSON api end point
    ///
    /// - Parameter phrase: Chinese phrase
    /// - Returns: Chinese definition in JSON
    func getChineseDefinition(fromEnglish phrase: String) -> Promise<[String: Any]>

    /// Gets the english definition from JSON api end point
    ///
    /// - Parameter phrase: Chinese idiom
    /// - Returns: Chinese definition in JSON
    func getChineseIdiomDefinition(fromIdiom phrase: String) -> Promise<[String: Any]>

}
