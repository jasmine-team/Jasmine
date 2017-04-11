import Foundation

/// Random generator that generates and exhausts the entire collection before starting over
class RandomGenerator<T> where T: Collection, T.Indices.Iterator.Element == T.Index {

    var collection: T
    var range: [T.Index] = []

    init(of collection: T) {
        self.collection = collection
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
        if range.isEmpty {
            range = collection.indices.shuffled()
        }
        let nextIndex = range.removeFirst()
        return collection[nextIndex]
    }

}
