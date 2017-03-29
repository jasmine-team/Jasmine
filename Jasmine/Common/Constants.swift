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

            static let upcomingTilesCount = 4

            static let tileFallInterval: TimeInterval = 0.5
        }
    }

    enum Theme {
        static let mainColor = FlatMint()
        static let mainColorDark = FlatMintDark()

        static let secondaryColor = UIColor(hexString: "ffd53f")

        static let mainWhiteColor = FlatWhite()
        static let mainFontColor = FlatBlack()

        static let tilesFont = UIFont(name: "HelveticaNeue-Light", size: 30.0)
        static let cellsBackground = UIColor(hexString: "c2d1cc")
    }

    enum Graphics {

        enum Explosion {
            static let frames = [#imageLiteral(resourceName: "explode-0"), #imageLiteral(resourceName: "explode-1"), #imageLiteral(resourceName: "explode-2"), #imageLiteral(resourceName: "explode-3"), #imageLiteral(resourceName: "explode-4")]
            static let interval: TimeInterval = 0.1
            static let duration: TimeInterval = 0.5
        }

    }

    enum Language: String {
        case english = "eng"
        case chinese = "cmn"
    }

    enum UserDefaultsKeys: String {
        case launchedBefore
    }

}
