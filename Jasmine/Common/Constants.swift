import ChameleonFramework
import Foundation

// swiftlint:disable nesting
enum Constants {
    enum Theme {
        static let mainColor = FlatMint()
        static let mainColorDark = FlatMintDark()

        static let secondaryColor = UIColor(hexString: "ffd53f")

        static let mainWhiteColor = FlatWhite()
        static let mainFontColor = FlatBlack()

        static let tilesFont = UIFont(name: "HelveticaNeue-Light", size: 30.0)
        static let cellsBackground = UIColor(hexString: "c2d1cc")

        static let gridSnappingDuration = 0.2
    }

    enum Graphics {
        enum Explosion {
            static let frames = [#imageLiteral(resourceName: "explode-0"), #imageLiteral(resourceName: "explode-1"), #imageLiteral(resourceName: "explode-2"), #imageLiteral(resourceName: "explode-3"), #imageLiteral(resourceName: "explode-4")]
            static let interval: TimeInterval = 0.1
            static let duration: TimeInterval = 0.5
        }

        enum Petals {
            static let frames = [#imageLiteral(resourceName: "petal-0"), #imageLiteral(resourceName: "petal-1"), #imageLiteral(resourceName: "petal-2"), #imageLiteral(resourceName: "petal-3"),
                                 #imageLiteral(resourceName: "petal-4"), #imageLiteral(resourceName: "petal-5"), #imageLiteral(resourceName: "petal-6"), #imageLiteral(resourceName: "petal-7")]
        }
    }

    enum Sound {
        enum Volume {
            static let min: Float = 0.0
            static let max: Float = 1.0
            static let range = min...max
        }

        enum Background: String {
            static let allValues = [greenStar, dogDays, grid]
            static let defaultPlaylist = [greenStar, dogDays, grid]

            case greenStar = "green_star.mp3"
            case dogDays = "dog_days.mp3"
            case grid = "grid.mp3"
        }

        enum Effect: String {
            /// Enable max of 5 effect sounds to be played at the same time
            static let concurrentLimit = 5
            static let allValues = [pop, bounce, snap]

            case pop = "pop.wav"
            case bounce = "bounce.wav"
            case snap = "snap.wav"
        }
    }

    enum UserDefaultsKeys: String {
        case launchedBefore
    }

}
