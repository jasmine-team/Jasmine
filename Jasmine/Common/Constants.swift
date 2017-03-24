import ChameleonFramework
import Foundation

enum Constants {
    enum Grid {
        static let rows = 4
        static let columns = 4
        static let time: TimeInterval = 60
    }

    enum Flappy {
        static let gameTitle = "Flappy game"
        static let gameInstruction = "Fly your bird through the correct tunnel"

        static let scoreIncrement = 1
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
