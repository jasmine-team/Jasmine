import RealmSwift

extension Realm {

    /// Gets the default URL from Realm. Throws a fatal error if it is nil.
    ///
    /// - Returns: the default URL as an URL to the file
    static var defaultURL: URL {
        guard let defaultUrl = Realm.Configuration.defaultConfiguration.fileURL else {
            fatalError("Default realm has no file path")
        }
        return defaultUrl
    }

}
