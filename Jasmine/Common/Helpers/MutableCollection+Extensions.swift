import CoreGraphics.CGBase

extension MutableCollection where Indices.Iterator.Element == Index {

    /// Shuffles the contents of this collection.
    mutating func shuffle() {
        guard count > 1 else {
            return
        }

        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: count, to: 1, by: -1)) {
            let distance = arc4random_uniform(numericCast(unshuffledCount))
            if distance > 0 {
                let i = index(firstUnshuffled, offsetBy: numericCast(distance))
                swap(&self[firstUnshuffled], &self[i])
            }
        }
    }
}
