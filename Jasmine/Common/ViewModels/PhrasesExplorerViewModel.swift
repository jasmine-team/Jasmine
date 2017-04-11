import Foundation

class PhrasesExplorerViewModel {
    /// The phrases inside this ViewModel
    private var allPhrasesWithSelection: [(phrase: Phrase, selected: Bool)]

    /// The indices of allPhrasesWithSelection that are shown to the user.
    private var rowIndices: [Int]

    /// Number of phrases that will be shown in the view
    var rowsShown: Int {
        return rowIndices.count
    }

    /// The ViewController that contains this ViewModel
    weak var viewControllerDelegate: PhrasesExplorerViewController?

    init(phrases: Phrases, amount: Int) {
        let listOfPhrases = phrases.randomGenerator.next(count: amount)
        allPhrasesWithSelection = listOfPhrases.map { ($0, false) }
        rowIndices = Array(0..<amount)
    }

    /// Gets the Chinese string and selected status of the given row.
    ///
    /// - Parameter row: the row of the table
    /// - Returns: the string and whether it's selected or not
    func get(at row: Int) -> (chinese: String, english: String, selected: Bool) {
        let realIndex = rowIndices[row]
        let phraseWithSelection = allPhrasesWithSelection[realIndex]
        return (chinese: phraseWithSelection.phrase.chinese.joined(),
                english: phraseWithSelection.phrase.english,
                selected: phraseWithSelection.selected)
    }

    /// Toggles the index given at the indices selected, i.e. remove if it exists, insert if not.
    ///
    /// - Parameter row: the row to be toggled
    func toggle(at row: Int) {
        let toggledIndex = rowIndices[row]
        allPhrasesWithSelection[toggledIndex].selected = !allPhrasesWithSelection[toggledIndex].selected
    }

    /// Searches with the given keyword. Updates rowIndices
    ///
    /// - Parameter keyword: the keyword for search
    func search(keyword: String) {
        guard keyword != "" else {
            reset()
            return
        }

        let keyword = keyword.lowercased()
        rowIndices = []
        for (idx, (phrase: phrase, selected: _)) in allPhrasesWithSelection.enumerated() {
            for txt in [phrase.pinyin.joined(), phrase.chinese.joined(), phrase.english] where txt.hasPrefix(keyword) {
                rowIndices.append(idx)
            }
        }
    }

    /// Resets the table from search.
    func reset() {
        rowIndices = Array(0..<allPhrasesWithSelection.count)
    }

    /// Returns the PhraseViewModel associated with the given row (index of the table).
    ///
    /// - Parameter row: the row that is pressed
    /// - Returns: the phrase VM to be segued with (to the PhraseVC)
    func getPhraseViewModel(at row: Int) -> PhraseViewModel {
        let index = rowIndices[row]
        return PhraseViewModel(phrase: allPhrasesWithSelection[index].phrase)
    }
}
