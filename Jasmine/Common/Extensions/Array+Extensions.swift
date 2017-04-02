func ==<T: Equatable>(lhs: [T], rhs: [T?]) -> Bool {
    guard lhs.count == rhs.count else {
        return false
    }

    for (lhsElement, rhsElement) in zip(lhs, rhs) {
        guard let rhsElement = rhsElement, rhsElement == lhsElement else {
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
