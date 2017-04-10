import Foundation

/// Random generator that generates and exhausts the entire collection before starting over
class RandomGenerator<T> where T: Collection {

    var collection: T
    var nextIndex: T.Index

    init(of collection: T) {
        self.collection = collection
        self.nextIndex = collection.startIndex
    }

    /// Returns a list of phrases
    ///
    /// - Parameter length: length of resulting array
    /// - Returns: An array of Phrase
    func next(count: Int) -> [T.Iterator.Element] {
        return (0..<count).map { _ in
            self.next()
        }
    }

    /// Returns the next phrase, non-exhaustively.
    ///
    /// - Returns: Phrase
    func next() -> T.Iterator.Element {
        if nextIndex > collection.endIndex {
            nextIndex = collection.startIndex
        }
        let phrase = collection[nextIndex]
        nextIndex = collection.index(after: nextIndex)
        return phrase
    }

}
