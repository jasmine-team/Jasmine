/// Implement this delegate for `TetrisGameViewModel` to call for updating and commanding the
/// implementing game view controller.
protocol TetrisGameViewControllerDelegate: BaseGameViewControllerDelegate {

    /// Tells the view controller to retrieve `upcomingTiles` and reload the view for the upcoming tiles.
    func redisplayUpcomingTiles()

    /// Tells the view controller to redisplay the falling tile with `tileText`
    func redisplayFallingTile(tileText: String)

    // MARK: Animation
    /// Animates the destroyed and shifted tiles
    ///
    /// - Parameter destroyedTiles: the destroyed set of coordinates
    /// - Parameter shiftedTiles: the shifted array of coordinates
    func animate(destroyedTiles: Set<Coordinate>, shiftedTiles: [(from: Coordinate, to: Coordinate)])
}
