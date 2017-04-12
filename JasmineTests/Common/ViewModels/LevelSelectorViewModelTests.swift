import XCTest
import RealmSwift
@testable import Jasmine

class LevelSelectorViewModelTests: RealmTestCase {
    var test1: Level!
    var test2: Level!
    var test3: Level!

    var originalLevels: [Level]!
    var customLevels: [Level]!

    private var viewModel: LevelSelectorViewModel!

    override func setUp() {
        super.setUp()
        test1 = Level(value: ["name": "test1", "isReadOnly": true])
        test2 = Level(value: ["name": "test2", "isReadOnly": false])
        test3 = Level(value: ["name": "test3", "isReadOnly": false])
        originalLevels = [test1]
        customLevels = [test2, test3]
        originalLevels.forEach(save)
        customLevels.forEach(save)

        viewModel = LevelSelectorViewModel()
    }

    func testProperties() {
        XCTAssertEqual([GameInfo.from(level: test1)],
                       viewModel.defaultLevels)
        XCTAssertEqual([GameInfo.from(level: test2), GameInfo.from(level: test3)],
                       viewModel.customLevels)
    }

    func testDeleteLevel() {
        viewModel.deleteCustomLevel(fromRow: 0)
        XCTAssertEqual([test3.name], viewModel.customLevels.map { $0.levelName })
    }
}
