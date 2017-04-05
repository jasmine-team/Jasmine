/// Implement this class to describe how a game can be played with a Tetris Game board.
protocol TetrisGameViewModelProtocol: BaseViewModelProtocol {

    /// Stores the upcoming tiles that will be dropped, where index 0 will be the first to fall.
    var upcomingTiles: [String] { get }

    /// Stores the falling tile text
    /// Initialized in init and gets changed in `landTile` and `swapFallingTile`
    /// Force unwrap so that self methods can be called in init
    var fallingTileText: String! { get }

    /// Returns the starting coordinate for a new falling tile
    ///
    /// - Returns: The coordinate to drop the new tile from
    var fallingTileStartCoordinate: Coordinate { get }

    // MARK: Game Operations
    /// Swaps the falling tile with the upcoming tile at `index`
    ///
    /// - Parameter index: The index of `upcomingTiles` to be swapped
    func swapFallingTile(withUpcomingAt index: Int)

    /// Checks if it is possible to shift the falling tile to the specified coordinate.
    ///
    /// - Parameter coordinate: The coordinate to check if it can be shifted to.
    /// - Returns: True if this shifting is allowed, false otherwise.
    func canShiftFallingTile(to coordinate: Coordinate) -> Bool

    /// Checks if tile can be landed at the specified coordinate
    ///
    /// - Parameter coordinate: The coordinate to check if the tile can be landed at
    /// - Returns: True if the tile can be landed at `coordinate`
    func canLandTile(at coordinate: Coordinate) -> Bool

    /// Returns the eventual landing coordinate of the tile based on its current coordinate at `from`
    ///
    /// - Parameter coordinate: The coordinate that the falling tile is currently at
    /// - Returns: The coordinate that the tile will end up landing at
    /// - Precondition: There must be an empty tile somewhere below `from` to land the tile at.
    ///                 This will hold as long as tile falls from top to bottom 
    ///                 and game ends when a tile lands on the top row without getting destroyed
    func getLandingCoordinate(from coordinate: Coordinate) -> Coordinate

    /// Lands the tile at the specified coordinate.
    /// Destroys tiles recursively and returns the sequence of destroyed tiles and shifted tiles
    /// eg. if the first shifting of tiles causes new phrase matches, 
    /// the subsequent destroyed and shifted tiles will be appended to the resulting array for sequential animation
    ///
    /// - Parameter coordinate: The coordinate at which the tile has landed at
    /// - Returns: An array of the destroyed and shifted tiles in sequential order
    func landTile(at coordinate: Coordinate) -> [(destroyedTiles: Set<Coordinate>,
                                                  shiftedTiles: [(from: Coordinate, to: Coordinate)])]
}
