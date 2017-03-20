/// Implement this delegate for `TetrisGameViewModel` to call for updating and commanding the
/// implementing game view controller.
protocol TetrisGameViewControllerDelegate: BaseGameViewControllerDelegate {

    /// Tells the view controller to retrieve `upcomingTiles` and reload the view for the upcoming tiles.
    func redisplayUpcomingTiles()

    // MARK: Animation
    /// Ask the view controller to animate the destruction of tiles at the specified coordinates.
    ///
    /// - Parameter coodinates: the set of coordinates to be destroyed.
    func animate(destroyTilesAt coodinates: Set<Coordinate>)
    
    /// Shifts the content of the tiles from Coordinate `from` to Coordinate `to`
    ///
    /// - Parameter coordinatesShifted: array of coordinates to shift
    func animate(shiftTiles coordinatesToShift: [(from: Coordinate, to: Coordinate)])
}
