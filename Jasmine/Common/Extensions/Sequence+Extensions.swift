extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }

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
