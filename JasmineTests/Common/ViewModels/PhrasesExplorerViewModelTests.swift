import XCTest
@testable import Jasmine

class PhrasesExplorerViewModelTests: XCTestCase {
    let count = 10
    var phrases: Phrases!
    var viewModel: PhrasesExplorerViewModel!

    override func setUp() {
        guard let gameData = try? GameDataFactory().createGame(difficulty: 0, type: .ciHui) else {
            XCTFail("Realm errors")
            return
        }
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
