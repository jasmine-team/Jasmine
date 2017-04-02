class SlidingGameViewModel: BaseGridViewModel {
    override func swapTiles(_ coord1: Coordinate, and coord2: Coordinate) -> Bool {
        guard abs(coord1.row - coord2.row) + abs(coord1.col - coord2.col) == 1 else {
            return false
        }

        super.swapTiles(coord1, and: coord2)
    }
}
