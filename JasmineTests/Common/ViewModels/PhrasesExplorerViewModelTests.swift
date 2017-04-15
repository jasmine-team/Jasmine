import XCTest
@testable import Jasmine

class PhrasesExplorerViewModelTests: RealmTestCase {
    var phrases: Phrases!
    var viewModel: PhrasesExplorerViewModel!

    override func setUp() {
        super.setUp()
        let gameData = createGameData(difficulty: 1, type: .ciHui)
        phrases = gameData.phrases
        viewModel = PhrasesExplorerViewModel(phrases: phrases)
    }

    func testInit() {
        XCTAssertEqual(phrases.count, viewModel.rowsShown)
    }

    func testGet() {
        for idx in 0..<phrases.count {
            let phraseTuple = viewModel.get(at: idx)
            XCTAssertFalse(phraseTuple.selected)
        }
    }

    func testToggle() {
        for idx in 0..<phrases.count {
            viewModel.toggle(at: idx)
            XCTAssert(viewModel.get(at: idx).selected)
            viewModel.toggle(at: idx)
            XCTAssertFalse(viewModel.get(at: idx).selected)
        }
    }

    func testSearch() {
        let originalCount = viewModel.rowsShown

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

        viewModel.search(keyword: "")
        XCTAssertEqual(originalCount, viewModel.rowsShown)
    }

    func testSearchDiacritics() {
        guard let pinyin = phrases.first?.pinyin.first?.applyingTransform(.stripDiacritics, reverse: false) else {
            XCTFail("Pinyin retrieval error")
            return
        }

        viewModel.search(keyword: String(pinyin))
        XCTAssert(viewModel.rowsShown > 0)
    }

    func testReset() {
        let originalCount = viewModel.rowsShown

        let phraseTuple = viewModel.get(at: 0)
        guard let firstChinese = phraseTuple.chinese.characters.first else {
            XCTFail("Chinese database error")
            return
        }

        viewModel.search(keyword: String(firstChinese))

        viewModel.reset()
        XCTAssertEqual(originalCount, viewModel.rowsShown)
    }

    func testGetPhraseViewModel() {
        let phraseTuple = viewModel.get(at: 0)
        let phraseViewModel = viewModel.getPhraseViewModel(at: 0)

        XCTAssertEqual(phraseViewModel.english, phraseTuple.english)
        XCTAssertEqual(phraseViewModel.hanZi, phraseTuple.chinese)
    }

    func testHasChangedSelectedPhrases() {
        viewModel.toggle(at: 0)
        XCTAssert(viewModel.hasChangedSelectedPhrases)
        viewModel.toggle(at: 1)
        XCTAssert(viewModel.hasChangedSelectedPhrases)
        viewModel.toggle(at: 0)
        XCTAssert(viewModel.hasChangedSelectedPhrases)
        viewModel.toggle(at: 1)
        XCTAssertFalse(viewModel.hasChangedSelectedPhrases)

        let viewModel2 = PhrasesExplorerViewModel(phrases: phrases, selectedPhrases: nil)
        viewModel2.toggle(at: 0)
        XCTAssert(viewModel2.hasChangedSelectedPhrases)
        viewModel2.toggle(at: 1)
        XCTAssert(viewModel2.hasChangedSelectedPhrases)
        viewModel2.toggle(at: 0)
        XCTAssert(viewModel2.hasChangedSelectedPhrases)
        viewModel2.toggle(at: 1)
        XCTAssertFalse(viewModel2.hasChangedSelectedPhrases)

        guard let phrase = phrases.first else {
            XCTFail("Phrases error")
            return
        }
        let viewModel3 = PhrasesExplorerViewModel(phrases: phrases, selectedPhrases: [phrase])
        viewModel3.toggle(at: 0)
        XCTAssertFalse(viewModel3.hasChangedSelectedPhrases)
        viewModel3.toggle(at: 1)
        XCTAssert(viewModel3.hasChangedSelectedPhrases)
        viewModel3.toggle(at: 0)
        XCTAssert(viewModel3.hasChangedSelectedPhrases)
        viewModel3.toggle(at: 1)
        XCTAssert(viewModel3.hasChangedSelectedPhrases)
        viewModel3.toggle(at: 0)
        XCTAssertFalse(viewModel3.hasChangedSelectedPhrases)
    }
}
