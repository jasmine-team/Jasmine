import CoreGraphics

/// Random number generator for different types
enum Random {

    /// Generates a random integer
    ///
    /// - Parameters:
    ///   - from: start of range, inclusive
    ///   - toInclusive: end of range, inclusive
    /// - Returns: a random number in the range
    static func integer(from: Int, toInclusive: Int) -> Int {
        assert(toInclusive > from, "`toInclusive` must be larger than `from` number")
        return from + Int(arc4random_uniform(UInt32(toInclusive - from + 1)))
    }

    /// Generates a random double
    ///
    /// - Parameters:
    ///   - from: start of range, inclusive
    ///   - toInclusive: end of range, inclusive
    /// - Returns: a random number in the range
    static func double(from: Double, toInclusive: Double) -> Double {
        assert(toInclusive > from, "`toInclusive` must be larger than `from` number")
        return from + (drand48() * (toInclusive - from))
    }
}
