enum Constants {

    enum Tetris {
        /// Number of rows on the grid
        static let rows = 12
        /// Number of cols on the grid
        static let columns = 8

        /// Interval (in seconds) to update the game state
        static let updateInterval = 0.3

        /// Reuse identifier for the cell, shifted to custom UICollectionViewCell class when created
        static let cellIdentifier = "tetrisCell"
    }

}
