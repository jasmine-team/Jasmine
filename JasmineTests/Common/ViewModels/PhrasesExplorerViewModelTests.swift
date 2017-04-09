import XCTest
@testable import Jasmine

class PhrasesExplorerViewModelTests: RealmTestCase {
    let count = 10
    var phrases: Phrases!
    var viewModel: PhrasesExplorerViewModel!

    override func setUp() {
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
        let chineses = phraseTuple.chinese.characters.map { String($0) }

        for text in chineses {
            viewModel.search(keyword: text)
            XCTAssert(viewModel.rowsShown > 0)
            let phraseTuple = viewModel.get(at: 0)

            XCTAssertEqual(phraseTuple.chinese, chineses.joined())
            XCTAssertFalse(phraseTuple.selected)
        }
    }
}
