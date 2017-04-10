import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // swiftlint:disable:previous vertical_parameter_alignment

        if UIApplication.isFirstLaunch {
            Prebundler.hydrateRealm() // add phrases
        }
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 2, // Set the new schema version.
            // We haven't migrated anything, so oldSchemaVersion = 0.
            // Realm will automatically detect new properties and removed properties
            // by accessing the oldSchemaVersion property.
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    migration.enumerateObjects(ofType: Level.className()) { _, newObject in
                        // combine name fields into a single field
                        newObject!["uuid"] = UUID().uuidString
                    }
                }
        })

        SoundService.sharedInstance.play(.dogDays)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state.
        // This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) 
        // or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. 
        // Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, 
        // and store enough application state information to restore your application 
        // to its current state in case it is terminated later.
        // If your application supports background execution, 
        // this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; 
        // here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. 
        // If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. 
        // See also applicationDidEnterBackground:.
    }

}
