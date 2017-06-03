import Foundation

class BaseSwappingViewModel: GridViewModel, SwappingViewModelProtocol {
    typealias Score = GameConstants.Swapping.Score

    /// The number of moves currently done.
    var moves: Int = 0

    /// Tells the Game Engine View Model that the user from the View Controller attempts to swap
    /// the specified two tiles.
    ///
    /// Note that if the tiles are swapped, `delegate.updateTiles(...)` should be called to update
    /// the grid data of the cell stored in the view controller. However, there is no need to call
    /// `delegate.redisplayTiles(...)` as it will be done implicitly by the view controller when
    /// the swapping is successful (determined by the returned value).
    ///
    /// - Parameters:
    ///   - coord1: One of the cells to be swapped.
    ///   - coord2: The other cell to be swapped.
    /// - Returns: Returns true if the two coordinates has be swapped, false otherwise.
    @discardableResult
    func swapTiles(_ coord1: Coordinate, and coord2: Coordinate) -> Bool {
        guard gridData[coord1] != nil && gridData[coord2] != nil else {
            return false
        }

        gridData.swap(coord1, coord2)
        moves += 1

        return true
    }

    /// Check what happens when game is won. If game is won, change game status and add score.
    func checkCorrectTiles() {
        var score = checkCorrectTiles(scoreForLine: Score.line)

        if highlightedCoordinates.count == gridData.count {
            score += max(Score.win + Int(round(timeRemaining * Score.multiplierFromTime)) -
                moves * Score.multiplierFromMoves, 0)
            gameStatus = .endedWithWon
        }

        currentScore = score
    }
}
