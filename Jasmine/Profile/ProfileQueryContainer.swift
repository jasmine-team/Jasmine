import RealmSwift

class ProfileQueryContainer {

    let realm: Realm
    let levelResults: Results<LevelResult>

    /// Initialize manager with realm instance, useful for testing
    ///
    /// - Parameter realm: realm instance
    init(realm: Realm) {
        self.realm = realm
        levelResults = realm.objects(LevelResult.self)
    }

    /// Initiates the query container with a default realm
    ///
    /// - Throws: realm error if unable to initialize
    convenience init() throws {
        self.init(realm: try Realm())
    }

    /// Returns times played between the two days
    ///
    /// - Parameters:
    ///   - startDate: start date inclusive
    ///   - endDate: end date inclusive
    /// - Returns: number of times played in this week
    func timesPlayed(between startDate: Date, and endDate: Date) -> Int {
        let predicate = NSPredicate(format: "timePlayed >= %@ AND timePlayed =< %@",
                                    argumentArray: [startDate, endDate])
        return levelResults.filter(predicate).count
    }

}
