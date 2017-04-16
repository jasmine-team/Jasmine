import XCTest
import Foundation
@testable import Jasmine

class ProfileQueryContainerTests: RealmTestCase {

    func testTimesPlayed_single() {
        let results = [
            LevelResult(value: ["timePlayed": Date()])
        ]
        results.forEach(save)

        let queryContainer = ProfileQueryContainer(realm: realm)
        let result = queryContainer.timesPlayed(from: Date(timeIntervalSinceNow: -1_000),
                                                toExclusive: Date(timeIntervalSinceNow: 1_000))
        XCTAssertEqual(result, results.count, "result not found")
    }

    func testTimesPlayed_outOfBounds() {
        let results = [
            LevelResult(value: ["timePlayed": Date()])
        ]
        results.forEach(save)

        let queryContainer = ProfileQueryContainer(realm: realm)
        let result = queryContainer.timesPlayed(from: Date(timeIntervalSinceNow: 1_000),
                                                toExclusive: Date(timeIntervalSinceNow: 2_000))
        XCTAssertEqual(result, 0, "result was found when there is none")
    }

}
