import Foundation

extension Collection where Indices.Iterator.Element == Index {

    /// Makes a random generator over the collection
    ///
    /// - Returns: a random generator over collection
    func makeRandomGenerator() -> RandomGenerator<Self> {
        return RandomGenerator(of: self)
    }

}
