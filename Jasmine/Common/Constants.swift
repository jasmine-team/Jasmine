import ChameleonFramework
import Foundation

// swiftlint:disable nesting
enum Constants {
    enum Game {
        enum Grid {
            static let rows = 4
            static let columns = 4
            static let time: TimeInterval = 60
            static let scoreMultiplierFromTime = 100
            static let timerInterval: TimeInterval = 0.1
        }

        enum Tetris {
            static let gameTitle = "Tetris Cheng Yu"
            static let gameInstruction = "Form Cheng Yu in a row or column to destroy the block"

            /// Number of rows on the grid
            static let rows = 12
            /// Number of cols on the grid
            static let columns = 8

            /// Total time allowed
            static let totalTime: TimeInterval = 120
            /// Interval to update the time
            static let timeInterval: TimeInterval = 1

            static let upcomingTilesCount = 3

            /// Reuse identifier for the cell
            /// TODO: can be shifted to custom UICollectionViewCell class when created
            static let cellIdentifier = "tetrisCell"
        }
    }

    enum Theme {
        static let mainColor = FlatMint()
        static let mainColorDark = FlatMintDark()

        static let mainWhiteColor = FlatWhite()
        static let mainFontColor = FlatBlack()

        static let tilesFont = UIFont(name: "HelveticaNeue-Light", size: 30.0)
    }

    enum Language: String {
        case english = "eng"
        case chinese = "cmn"
    }

    enum UserDefaultsKeys: String {
        case launchedBefore
    }

}
