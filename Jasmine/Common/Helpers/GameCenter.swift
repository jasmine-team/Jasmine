import GameKit
import RealmSwift

/// Helper functions to report to game center
class GameCenter {

    let realm: Realm
    let results: Results<LevelResult>
    private var resultsNotifier: NotificationToken?

    init(realm: Realm) {
        self.realm = realm
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
                print("TESTER", tester, results[tester].level?.uuid ?? "FAIL")
            }
        case .error(let error):
            // An error occurred while opening the Realm file on the background worker thread
            assertionFailure("\(error)")
        }
    }

    func submitScore() {
        print("SUBMITTING")
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: "Test")
        bestScoreInt.value = Int64(10)
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
