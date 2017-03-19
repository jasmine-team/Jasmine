import RealmSwift

extension Realm {

    static var defaultURL: URL {
        guard let defaultUrl = Realm.Configuration.defaultConfiguration.fileURL else {
            fatalError("Default realm has no file path")
        }
        return defaultUrl
    }

}
