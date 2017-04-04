import Foundation

class BaseSwappingViewModel: GridViewModel, SwappingViewModelProtocol {
    /// The number of moves currently done.
    var moves: Int = 0

    /// Initializes the grid VM.
    ///
    /// - Parameters:
    ///   - time: total time allowed
    ///   - tiles: tiles in the game
    ///   - possibleAnswers: all possible answers. The game is won if all rows in the game is in all possible answers.
    ///   - rows: number of rows in the grid.
    ///   - columns: number of columns in the grid.
    init(time: TimeInterval, gameData: GameData, tiles: [String], rows: Int, columns: Int) {
        assert(rows > 0 && columns > 0, "Number of rows and columns should be more than 0")
        assert(tiles.count == rows * columns, "Number of tiles should equal numRows * numColumns")

        let shuffledTiles = tiles.shuffled()
        let grid = (0..<rows).map { row in
            (0..<columns).map { col in
                shuffledTiles[row * columns + col]
            }
        }

        super.init(time: time, gameData: gameData, textGrid: TextGrid(fromInitialGrid: grid))
    }

    /// Score for the game when it is won on the current state.
    override var score: Int {
        return max(Constants.Game.Swapping.Score.base +
            Int(timeRemaining * Constants.Game.Swapping.Score.multiplierFromTime)
            - moves * Constants.Game.Swapping.Score.multiplierFromMoves, 0)
    }

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

        checkGameWon()

        return true
    }
}
