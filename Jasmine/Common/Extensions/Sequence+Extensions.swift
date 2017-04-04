extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }

    /// Returns true if and only if all elements in the array satisfy the given condition.
    ///
    /// - Parameter predicate: the condition, that takes in an element and returns true/false
    /// - Returns: true if and only if all elements in the array satisfies the condition
    func isAllTrue(predicate: (Iterator.Element) -> Bool) -> Bool {
        return first(where: { !predicate($0) }) == nil
    }
}

extension Sequence where Iterator.Element: Hashable {
    var isAllSame: Bool {
        return Set(self).count <= 1
    }
}
