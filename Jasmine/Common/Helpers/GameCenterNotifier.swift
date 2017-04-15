import GameKit
import RealmSwift


/// Helper functions to report to game center
class GameCenterNotifier {
    
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
    let results: Results<LevelResult>
    let player: Player
    private var resultsNotifier: NotificationToken?
    
    init(realm: Realm, player: Player) {
        self.realm = realm
        self.player = realm.objects(Player.self).first ?? Player()
        results = realm.objects(LevelResult.self)
        attachListeners()
    }
    
    func attachListeners() {
        resultsNotifier = results.addNotificationBlock(resultsChanged)
    }
    
    func resultsChanged(changes: RealmCollectionChange<Results<LevelResult>>) {
        print("TEST")
        switch changes {
        case .initial:
            print("IS WORKING")
            return
        case .update(_, _, let insertions, _):
            // results will only ever be inserted, not updated or deleted (unless user reset)
            print("UPDATE")
            insertions.forEach { tester in
                updateFor(result: results[tester])
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
        guard let identifier = GameCenterNotifier.UUIDToIdentifier[level.uuid] else {
            return  // not a original level
        }
        submit(score: result.score, for: identifier)
    }
    
    func submit(score: Int, for identifier: String) {
        print("SUBMITTING")
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: identifier)
        bestScoreInt.value = Int64(score)
        GKScore.report([bestScoreInt]) { error in
            guard let error = error else {
                return
            }
            print(error.localizedDescription)
        }
    }
    
    func achieve() {
        let achievement = GKAchievement(identifier: "test.first")
        
        achievement.percentComplete = 100
        achievement.showsCompletionBanner = true  // use Game Center's UI
        
        GKAchievement.report([achievement]) { error in
            guard let error = error else {
                return
            }
            print(error.localizedDescription)
        }
    }
    
    // Detach listeners to realm collections
    deinit {
        resultsNotifier = nil
    }
    
}
