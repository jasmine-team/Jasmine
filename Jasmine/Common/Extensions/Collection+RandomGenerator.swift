import Foundation

extension Collection where Indices.Iterator.Element == Index {

    /// Makes a random generator over the collection
    ///
    /// - Returns: a random generator over collection
    var randomGenerator: RandomGenerator<Self> {
        return RandomGenerator(of: self)
    }

}
