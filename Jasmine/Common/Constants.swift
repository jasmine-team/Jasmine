import ChameleonFramework

enum Constants {

    enum BoardGamePlay {
        static let rows: Int = 4
        static let columns: Int = 4
    }

    enum Theme {
        static let mainColor = FlatMint()
        static let mainColorDark = FlatMintDark()

        static let mainWhiteColor = FlatWhite()
        static let mainFontColor = FlatBlack()

        static let tilesFont = UIFont(name: "HelveticaNeue-Light", size: 30.0)
    }
}
