import RealmSwift

class ResultsQueryContainer {

    let realm: Realm
    let levelResults: Results<LevelResult>
    
    let slidingResults: Results<LevelResult>
    let tetrisResults: Results<LevelResult>
    let swappingResults: Results<LevelResult>

    /// Initialize manager with realm instance, useful for testing
    ///
    /// - Parameter realm: realm instance
    init(realm: Realm) {
        self.realm = realm
        levelResults = realm.objects(LevelResult.self)
        
        slidingResults = levelResults.filter("ANY level.gameMode = 'sliding'")
        tetrisResults = levelResults.filter("ANY level.gameMode = 'tetris'")
        swappingResults = levelResults.filter("ANY level.gameMode = 'swapping'")
    }
    
    /// Initiates the query container with a default realm
    ///
    /// - Throws: realm error if unable to initialize
    convenience init() throws {
        self.init(realm: try Realm())
    }
<<<<<<< HEAD:Jasmine/Common/Models/ResultsQueryContainer.swift
    
    /// Returns times played between the two days
=======

    /// Returns times played between the two dates
>>>>>>> origin/master:Jasmine/Profile/Models/ProfileQueryContainer.swift
    ///
    /// - Parameters:
    ///   - startDate: start date inclusive
    ///   - endDate: end date exclusive
    /// - Returns: number of times played between `startDate` and `endDate`
    func timesPlayed(from startDate: Date, toExclusive endDate: Date) -> Int {
        let predicate = NSPredicate(format: "timePlayed >= %@ AND timePlayed < %@",
                                    argumentArray: [startDate, endDate])
        return levelResults.filter(predicate).count
    }
    
}
