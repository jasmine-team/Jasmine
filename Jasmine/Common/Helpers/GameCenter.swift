import GameKit
import RealmSwift

protocol GKScoreProtocol {
    var value: Int64 { get set }
    func report(_ scores: [GKScore], withCompletionHandler completionHandler: ((Error?) -> Void)?) -> Void
}

extension GKScore: GKScoreProtocol {}

protocol GameCenterReporter {
    var notifier: NotificationToken? { get }
    
    func action() -> Void
}

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
        switch changes {
        case .initial:
            print("IS WORKING")
            return
        case .update(_, _, let insertions, _):
            // results will only ever be inserted, not updated or deleted (unless user reset)
            insertions.forEach { tester in
                print(tester)
            }
        case .error(let error):
            // An error occurred while opening the Realm file on the background worker thread
            assertionFailure("\(error)")
        }
    }

    func submitScore() {
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: "test")
        bestScoreInt.value = Int64(10)
        GKScore.report([bestScoreInt]) { error in
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
