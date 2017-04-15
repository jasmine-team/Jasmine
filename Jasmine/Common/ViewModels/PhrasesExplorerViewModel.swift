import Foundation

class PhrasesExplorerViewModel {
    /// The phrases inside this ViewModel
    private var allPhrasesWithSelection: [(phrase: Phrase, selected: Bool)]

    var selectedPhrases: Set<Phrase> {
        return Set(allPhrasesWithSelection.filter { $0.selected }.map { $0.phrase })
    }

    /// The indices of allPhrasesWithSelection that are shown to the user.
    private var rowIndices: [Int]

    /// Number of phrases that will be shown in the view
    var rowsShown: Int {
        return rowIndices.count
    }

    /// The ViewController that contains this ViewModel
    weak var viewControllerDelegate: PhrasesExplorerViewController?

    /// The initially selected phrases passed to the VM
    private var initialPhrases: Set<Phrase>
    /// Indicates if currently selected phrases is different from initial phrases passed to the VM.
    /// Used to check if it's necessary to warn the user about exit without savings
    var hasChangedSelectedPhrases: Bool {
        print("Initial phrases: \(initialPhrases.map { $0.chinese.joined() })")
        print("Selected phrases: \(selectedPhrases.map { $0.chinese.joined() })")
        return initialPhrases != selectedPhrases
    }

    init(phrases: Phrases, selectedPhrases: Set<Phrase>? = nil) {
        initialPhrases = selectedPhrases ?? []
        allPhrasesWithSelection = phrases.map { phrase in
            (phrase, selectedPhrases?.contains(phrase) ?? false)
        }
        rowIndices = Array(0..<phrases.count)
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
            guard let pinyin = phrase.pinyin.joined().applyingTransform(.stripDiacritics, reverse: false) else {
                assertionFailure("Diacritics cannot be stripped. Swift failure")
                continue
            }

            for txt in [pinyin, phrase.chinese.joined(), phrase.english] where txt.hasPrefix(keyword) {
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
