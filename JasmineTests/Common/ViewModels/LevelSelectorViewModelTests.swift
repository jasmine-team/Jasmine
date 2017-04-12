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
        XCTAssertEqual([GameInfo.constructGameInfo(from: test1)],
                       viewModel.defaultLevels)
        XCTAssertEqual([GameInfo.constructGameInfo(from: test2), GameInfo.constructGameInfo(from: test3)],
                       viewModel.customLevels)
    }

    func testDeleteLevel() {
        viewModel.deleteLevel(from: GameInfo.constructGameInfo(from: test2))
        XCTAssertEqual([test3.name], viewModel.customLevels.map { $0.levelName })
    }
}
