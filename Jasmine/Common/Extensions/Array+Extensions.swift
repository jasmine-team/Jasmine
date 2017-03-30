func ==<T: Equatable>(lhs: [T], rhs: [T?]) -> Bool {
    guard lhs.count == rhs.count else {
        return false
    }

    for idx in 0..<lhs.count {
        guard let rhsElement = rhs[idx], lhs[idx] == rhsElement else {
            return false
        }
    }

    return true
}

func ==<T: Equatable>(lhs: [T?], rhs: [T]) -> Bool {
    return rhs == lhs
}

func !=<T: Equatable>(lhs: [T], rhs: [T?]) -> Bool {
    return !(lhs == rhs)
}

func !=<T: Equatable>(lhs: [T?], rhs: [T]) -> Bool {
    return rhs != lhs
}
