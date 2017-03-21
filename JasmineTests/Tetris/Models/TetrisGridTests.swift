import XCTest
@testable import Jasmine

class TetrisGridTests: XCTestCase {

    func testInit() {
        let grid = TetrisGrid()
        let coordinate = Coordinate(row: 0, col: 0)
        XCTAssertNil(grid.get(at: coordinate), "Initialization is not empty")
        XCTAssertFalse(grid.hasTile(at: coordinate), "Initialization is not empty")
        XCTAssertNil(grid.remove(at: coordinate), "Initialization is not empty")
    }

    func testGet() {
        let grid = TetrisGrid()
        let coordinate = Coordinate(row: 1, col: 1)
        let tileText = "test"
        grid.add(at: coordinate, tileText: tileText)
        XCTAssertNil(grid.get(at: Coordinate(row: 0, col: 0)), "Get at empty tile is not nil")
        XCTAssertEqual(grid.get(at: coordinate), tileText, "Get returns wrong value")
    }

    func testHasTile() {
        let grid = TetrisGrid()
        let coordinate = Coordinate(row: 1, col: 1)
        grid.add(at: coordinate, tileText: "test")
        XCTAssertFalse(grid.hasTile(at: Coordinate(row: 0, col: 0)), "hasTile returns false positive")
        XCTAssert(grid.hasTile(at: coordinate), "hasTile returns false negative")
    }

    func testAdd() {
        let grid = TetrisGrid()
        let tile1 = (coordinate: Coordinate(row: 0, col: 0), tileText: "test")
        let tile2 = (coordinate: Coordinate(row: 0, col: 1), tileText: "test2")
        grid.add(at: tile1.coordinate, tileText: tile1.tileText)
        grid.add(at: tile2.coordinate, tileText: tile2.tileText)
        XCTAssertEqual(grid.get(at: tile1.coordinate), tile1.tileText, "Retrieved wrong tile after adding")
        XCTAssertEqual(grid.get(at: tile2.coordinate), tile2.tileText, "Retrieved wrong tile after adding")
    }

    func testRemove() {
        let grid = TetrisGrid()
        let coordinateToRemoveLater = Coordinate(row: 1, col: 1)
        let coordinateToRetain = Coordinate(row: 0, col: 1)
        grid.add(at: coordinateToRemoveLater, tileText: "test")
        grid.add(at: coordinateToRetain, tileText: "test")
		_ = grid.remove(at: coordinateToRemoveLater)
        XCTAssertFalse(grid.hasTile(at: coordinateToRemoveLater), "Failed to remove tile")
        XCTAssert(grid.hasTile(at: coordinateToRetain), "Wrong tile removed")
    }

    func testRemoveMultiple() {
        let grid = TetrisGrid()
        var coordinatesToRemove: Set<Coordinate> = []
        coordinatesToRemove.insert(Coordinate(row: 1, col: 1))
        coordinatesToRemove.insert(Coordinate(row: 0, col: 0))
        let coordinateToRetain = Coordinate(row: 0, col: 1)
        grid.add(at: coordinateToRetain, tileText: "test")
        for coordinate in coordinatesToRemove {
        	grid.add(at: coordinate, tileText: "test")
        }
        grid.remove(at: coordinatesToRemove)

        for coordinate in coordinatesToRemove {
            XCTAssertFalse(grid.hasTile(at: coordinate), "Failed to remove tile")
        }
        XCTAssert(grid.hasTile(at: coordinateToRetain), "Wrong tile removed")
    }
}
