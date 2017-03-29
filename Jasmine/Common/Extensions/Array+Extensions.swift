extension Array where Element: Equatable {
    /// Returns an array with the contents of this sequence, shuffled.
    func isSubsequenceOf(_ other: [Element]) -> Bool {
        for otherIndex in 0..<(other.count - count) {
            var inThisRow = true

            for selfIndex in 0..<count {
                if self[selfIndex + otherIndex] != other[otherIndex] {
                    inThisRow = false
                    break
                }
            }

            if inThisRow {
                return true
            }
        }

        return false
    }
}
