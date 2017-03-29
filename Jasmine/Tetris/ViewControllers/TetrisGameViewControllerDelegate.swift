/// Implement this delegate for `TetrisGameViewModel` to call for updating and commanding the
/// implementing game view controller.
protocol TetrisGameViewControllerDelegate: BaseGameViewControllerDelegate {

    /// Tells the view controller to retrieve `upcomingTiles` and reload the view for the upcoming tiles.
    func redisplayUpcomingTiles()

    /// Tells the view controller to redisplay the falling tile with `tileText`
    func redisplayFallingTile(tileText: String)

    // MARK: Animation
    /// Ask the view controller to animate the destruction of tiles at the specified coordinates.
    ///
    /// - Parameter coodinates: the set of coordinates to be destroyed.
    func animate(destroyTilesAt coordinates: Set<Coordinate>)

    /// Shifts the content of the tiles from Coordinate `from` to Coordinate `to`
    ///
    /// - Parameter coordinatesShifted: array of coordinates to shift
    func animate(shiftTiles coordinatesToShift: [(from: Coordinate, to: Coordinate)])

    /// Ask the view controller to animate the destruction of tiles at the specified coordinates,
    /// and then shift the content of the tiles from Coordinate `from` to Coordinate `to`.
    ///
    /// - Parameters:
    ///   - coodinates: the set of coordinates to be destroyed.
    ///   - coordinatesShifted: array of coordinates to shift
    func animate(destroyTilesAt coordinates: Set<Coordinate>,
                 thenShiftTiles coordinatesToShift: [(from: Coordinate, to: Coordinate)])
}
