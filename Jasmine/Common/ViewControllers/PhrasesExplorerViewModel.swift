import Foundation

class PhrasesExplorerViewModel {
    /// The phrases inside this ViewModel
    private let phrases: Phrases

    /// The Chinese characters used for display
    let chineseSet: NSOrderedSet

    /// The set of indices that are selected
    var indicesSelected: Set<Int>

    /// Number of phrases in this ViewModel
    let amount: Int

    weak var viewControllerDelegate: PhrasesExplorerViewController?

    init(phrases: Phrases, amount: Int, indicesSelected: Set<Int> = []) {
        self.phrases = phrases
        self.amount = amount
        self.indicesSelected = indicesSelected
        chineseSet = NSOrderedSet(array: phrases.next(count: amount).map { $0.chinese.joined() })
    }

    /// Toggles the index given at the indices selected, i.e. remove if it exists, insert if not.
    ///
    /// - Parameter index: the index to be toggled
    func toggle(at index: Int) {
        if indicesSelected.contains(index) {
            indicesSelected.remove(index)
        } else {
            indicesSelected.insert(index)
        }
    }
}
