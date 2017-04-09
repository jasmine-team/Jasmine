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
        allPhrasesWithSelection = phrases.next(count: amount).map { ($0, false) }
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
        let keyword = keyword.lowercased()
        rowIndices = []
        for (idx, (phrase: phrase, selected: _)) in allPhrasesWithSelection.enumerated() {
            if [phrase.pinyin, phrase.chinese].flatMap({ $0 }).contains(where: { $0 == keyword }) {
                rowIndices.append(idx)
            }
        }
    }
}
