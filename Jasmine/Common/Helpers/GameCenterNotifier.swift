import GameKit
import RealmSwift


/// Helper functions to report to game center
class GameCenterNotifier {

    static let bronzePlaycount = (requiredCount: 10, identifier: "combined.playcount.bronze")
    static let silverPlaycount = (requiredCount: 100, identifier: "combined.playcount.silver")
    static let goldPlaycount = (requiredCount: 1000, identifier: "combined.playcount.gold")

    fileprivate static let UUIDToIdentifier: [String: String] = {
        let uuids = [
            "EE8A0045-4B64-4840-855D-584C283FBE1F"
        ]
        var dict: [String: String] = [:]
        for (i, uuid) in uuids.enumerated() {
            dict[uuid] = "single.leaderboard.\(i + 1)"
        }
        return dict
    }()
    
    let realm: Realm
    let results: ResultsQueryContainer

    private var resultsNotifier: NotificationToken?

    var gameCenterReporter: (Error?) -> Void {
        return { error in
            guard let error = error else {
                return
            }
            print(error.localizedDescription)
        }
    }
    
    init(realm: Realm) {
        self.realm = realm
        results = ResultsQueryContainer(realm: realm)
        attachListeners()
    }
    
    func attachListeners() {
        resultsNotifier = results.levelResults.addNotificationBlock(resultsChanged)
    }
    
    func resultsChanged(changes: RealmCollectionChange<Results<LevelResult>>) {
        switch changes {
        case .initial:
            return
        case .update(_, _, let insertions, _):
            // results will only ever be inserted, not updated or deleted (unless user reset)
            insertions.forEach { tester in
                updateFor(result: results.levelResults[tester])
            }
        case .error(let error):
            // An error occurred while opening the Realm file on the background worker thread
            assertionFailure("\(error)")
        }
    }
    
    func updateFor(result: LevelResult) {
        guard let level = result.level else {
            assertionFailure("Level was not attached")
            return
        }
        updateTotalPlaycount()
        guard let identifier = GameCenterNotifier.UUIDToIdentifier[level.uuid] else {
            return  // not a original level
        }
        submit(score: result.score, for: identifier)
    }
    
    /// Updates total playcount achievement
    private func updateTotalPlaycount() {
        let playcount = results.levelResults.count
        
        let bronze = GameCenterNotifier.bronzePlaycount
        let silver = GameCenterNotifier.silverPlaycount
        let gold = GameCenterNotifier.goldPlaycount
        
        switch playcount {
        case 0...bronze.requiredCount:
            submit(achievementProgress: Double(playcount / bronze.requiredCount), 
                   for: bronze.identifier)
        case bronze.requiredCount...silver.requiredCount:
            submit(achievementProgress: Double(playcount / silver.requiredCount), 
                   for: silver.identifier)
        case silver.requiredCount...gold.requiredCount:
            submit(achievementProgress: Double(playcount / gold.requiredCount), 
                   for: gold.identifier)
        default:
            return  // maxed out achievement
        }
    }
    
    /// Helper function to submite game center score
    ///
    /// - Parameters:
    ///   - score: score to report
    ///   - identifier: identifier of the leaderboards
    private func submit(score: Int, for identifier: String) {
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: identifier)
        bestScoreInt.value = Int64(score)
        GKScore.report([bestScoreInt], withCompletionHandler: gameCenterReporter)
    }

    /// Submits achievement progress to game center
    ///
    /// - Parameters:
    ///   - achievementProgress: progress in terms of percentage
    ///   - identifier: identifier of achievement
    private func submit(achievementProgress: Double, for identifier: String) {
        let achievement = GKAchievement(identifier: identifier)
        achievement.percentComplete = achievementProgress
        achievement.showsCompletionBanner = true  // use Game Center's UI
        
        GKAchievement.report([achievement], withCompletionHandler: gameCenterReporter)
    }
    
}
