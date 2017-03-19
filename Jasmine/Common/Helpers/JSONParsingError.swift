/// JSON error for indicating that the part is invalid or malformed
///
/// - invalidDictionary: invalide [String: Any] cast
/// - invalidArray: invalide [Any] cast
/// - invalidString: invalide String cast
enum JSONParsingError: Error {
    case invalidDictionary, invalidArray, invalidString
}
