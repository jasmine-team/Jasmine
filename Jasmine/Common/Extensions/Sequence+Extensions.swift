extension Sequence {
    /// Returns an array with the contents of this sequence, shuffled.
    func shuffled() -> [Iterator.Element] {
        var result = Array(self)
        result.shuffle()
        return result
    }

    /// Generates an even permutation (shuffle) of the array uniformly random. An even permutation
    /// is defined such that the number of swaps from the original array to the produced array is
    /// even.
    ///
    /// - Returns: an even permutation (shuffle) of the array
    func evenPermutation() -> [Iterator.Element] {
        let array = Array(self)
        var indexShuffle = (0..<array.count).shuffled()

        var swapDistance = 0
        for (idx, elem) in indexShuffle.enumerated() {
            swapDistance += abs(idx - elem)
        }

        // Make swapDistance even
        if swapDistance % 2 == 1 {
            swap(&indexShuffle[0], &indexShuffle[1])
        }

        return indexShuffle.map { array[$0] }
    }
}

extension Sequence where Iterator.Element: Hashable {
    var isAllSame: Bool {
        return Set(self).count <= 1
    }
}
