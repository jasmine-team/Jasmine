import XCTest
@testable import Jasmine

class PhrasesExplorerViewModelTests: RealmTestCase {
    let count = 10
    var phrases: Phrases!
    var viewModel: PhrasesExplorerViewModel!

    override func setUp() {
        super.setUp()
        let gameData = createGameData(difficulty: 1, type: .ciHui)
        phrases = gameData.phrases
        viewModel = PhrasesExplorerViewModel(phrases: phrases, amount: count)
    }

    func testInit() {
        XCTAssertEqual(10, viewModel.rowsShown)
    }

    func testGet() {
        for idx in 0..<10 {
            let phraseTuple = viewModel.get(at: idx)
            XCTAssertFalse(phraseTuple.selected)
        }
    }

    func testToggle() {
        for idx in 0..<10 {
            viewModel.toggle(at: idx)
            XCTAssert(viewModel.get(at: idx).selected)
            viewModel.toggle(at: idx)
            XCTAssertFalse(viewModel.get(at: idx).selected)
        }
    }

    func testSearch() {
        let phraseTuple = viewModel.get(at: 0)
        guard let firstChinese = phraseTuple.chinese.characters.first else {
            XCTFail("Chinese database error")
            return
        }

        viewModel.search(keyword: String(firstChinese))
        XCTAssert(viewModel.rowsShown > 0)
        let phrase = viewModel.get(at: 0)

        XCTAssertEqual(phraseTuple.chinese, phrase.chinese)
        XCTAssertFalse(phraseTuple.selected)
    }
}
