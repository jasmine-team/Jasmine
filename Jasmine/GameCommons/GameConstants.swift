import Foundation

// swiftlint:disable nesting
enum GameConstants {

    /// The time interval to run at for the game clock
    static let timeInterval: TimeInterval = 0.1

    enum Swapping {
        enum CiHui {
            static let gameInstruction = "Match the Chinese characters with their Pinyins " +
                                         "by putting them in one row/column."
        }

        enum ChengYu {
            static let gameInstruction = "Match the Cheng Yus by putting them in one row/column."
        }

        enum Score {
            static let line = 1_000
            static let win = 5_000
            static let multiplierFromTime: Double = 100
            static let multiplierFromMoves = 50
        }

        static let rows = 4
        static let columns = 4
        static let time: TimeInterval = 60
    }

    enum Sliding {
        enum CiHui {
            static let gameInstruction = "Match the Chinese characters with their Pinyins " +
                                         "by putting them in one row/column."
        }

        enum ChengYu {
            static let gameInstruction = "Match the Cheng Yus by putting them in one row/column."
        }

        enum Score {
            static let line = 1_000
            static let win = 5_000
            static let multiplierFromTime: Double = 100
            static let multiplierFromMoves = 25
        }

        static let rows = 4
        static let columns = 4
        static let time: TimeInterval = 600
    }

    enum Tetris {
        enum CiHui {
            static let gameInstruction = "Form Ci Hui from left to right or top to bottom to destroy the blocks"
        }

        enum ChengYu {
            static let gameInstruction = "Form Cheng Yu from left to right or top to bottom to destroy the blocks"
        }

        /// Number of rows on the grid
        static let rows = 12
        /// Number of cols on the grid
        static let columns = 8

        /// Total time allowed
        static let totalTime: TimeInterval = 120

        /// Number of distinct phrases in the upcoming tiles pool
        static let upcomingPhrasesCount = 2

        static let tileFallInterval: TimeInterval = 0.5

        static let scoreIncrement = 100
    }

    enum GameOver {
        static let titleLose = "GAME OVER"
        static let subtitleLose = "PLEASE TRY AGAIN NEXT TIME"

        static let titleWin = "CONGRATULATIONS"
        static let subtitleWin = "YOU HAVE CLEARED THIS LEVEL"
    }
}
