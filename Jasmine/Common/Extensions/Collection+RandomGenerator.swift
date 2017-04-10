import Foundation

extension Collection {

    /// Makes a random generator over the collection
    ///
    /// - Returns: a random generator over collection
    func makeRandomGenerator() -> RandomGenerator<Self> {
        return RandomGenerator(of: self)
    }

}
