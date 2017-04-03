extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }

    /// Returns true if and only if all elements in the array satisfy the given condition.
    ///
    /// - Parameter condition: the condition, that takes in an element and returns true/false
    /// - Returns: true if and only if all elements in the array satisfies the condition
    func isAll(condition: (Iterator.Element) -> Bool) -> Bool {
        return reduce(true) { accum, next in
            return accum && condition(next)
        }
    }
}

extension Sequence where Iterator.Element: Hashable {
    var isAllSame: Bool {
        return Set(self).count <= 1
    }
}
