func ==<T: Equatable>(lhs: [[T]], rhs: [[T]]) -> Bool {
    if lhs.count != rhs.count {
        return false
    }

    for i in 0..<lhs.count where lhs[i] != rhs[i] {
        return false
    }

    return true
}
