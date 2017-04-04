import Foundation
@testable import Jasmine

class GridViewModelSameRowMock: GridViewModel {
    override var score: Int {
        return 10
    }

    override func lineIsCorrect(_ line: [Coordinate]) -> Bool {
        return line.map { $0.row }.isAllSame
    }
}

class GridViewModelSameColumnMock: GridViewModel {
    override var score: Int {
        return 10
    }

    override func lineIsCorrect(_ line: [Coordinate]) -> Bool {
        return line.map { $0.col }.isAllSame
    }
}
