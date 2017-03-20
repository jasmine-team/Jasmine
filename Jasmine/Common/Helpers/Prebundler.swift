import Foundation
import RealmSwift

/// Prebundler that injects prebundled realm file into app
struct Prebundler {

    /// Prebundled realm file name, must end in .realm extension
    fileprivate static let prebundledFileName = "prebundled.realm"

    /// Replaces the prebundled realm file over to default realm
    static func hydrateRealm() {
        guard let resourceUrl = Bundle.main.resourceURL else {
            fatalError("Main bundle does not have a resource URL")
        }
        let prebundledUrl = resourceUrl.appendingPathComponent(Prebundler.prebundledFileName)
        do {
            try FileManager.default.copyItem(at: prebundledUrl, to: Realm.defaultURL)
        } catch let error {
            fatalError("Error: \(error.localizedDescription)")
        }
    }

}
