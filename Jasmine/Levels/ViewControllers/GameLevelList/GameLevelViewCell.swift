import UIKit

/// Displays a level as a view cell in a collection view.
class GameLevelViewCell: UICollectionViewCell {

    // MARK: Constants
    private static let titleIdentifier = "LevelTitle"
    private static let gameModeIdentifier = "GameModeLabel"
    private static let gameTypeIdentifier = "GameTypeLabel"
    private static let checkmarkIdentifier = "CheckImage"

    private static let gameModeText: [GameMode: String] = [
        .sliding: "SLIDING", .swapping: "SWAPPING", .tetris: "TETRIS"
    ]

    private static let gameTypeText: [GameType: String] = [
        .chengYu: "CHENGYU", .ciHui: "CIHUI"
    ]

    // MARK: Layouts
    private lazy var titleLabel: UILabel
        = { self.retrieveView(withIdentifier: GameLevelViewCell.titleIdentifier) }()

    private lazy var gameModeLabel: UILabel
        = { self.retrieveView(withIdentifier: GameLevelViewCell.gameModeIdentifier) }()

    private lazy var gameTypeLabel: UILabel
        = { self.retrieveView(withIdentifier: GameLevelViewCell.gameTypeIdentifier) }()

    private lazy var checkmarkImage: UIImageView
        = { self.retrieveView(withIdentifier: GameLevelViewCell.checkmarkIdentifier) }()

    /// Helper method that retrieves the appropriate view based on identifier.
    private func retrieveView<T: UIView>(withIdentifier identifier: String) -> T {
        let possibleView = self.allSubviews.first { $0.restorationIdentifier == identifier }
        guard let foundView = possibleView as? T else {
            fatalError("View with identifier: \(identifier) not found.")
        }
        return foundView
    }

    // MARK: Game Data
    var isMarked: Bool {
        set {
            checkmarkImage.isHidden = !newValue
        }
        get {
            return !checkmarkImage.isHidden
        }
    }

    func set(title: String?) {
        titleLabel.text = title
    }

    func set(gameMode: GameMode) {
        gameModeLabel.text = GameLevelViewCell.gameModeText[gameMode]
    }

    func set(gameType: GameType) {
        gameTypeLabel.text = GameLevelViewCell.gameTypeText[gameType]
    }
}
