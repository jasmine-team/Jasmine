class FlappyViewModel {

    weak var delegate: FlappyViewControllerDelegate?
    fileprivate var correctOptionIndex: Int?

    fileprivate(set) var currentScore: Int = 0 {
        didSet {
            delegate?.redisplay(newScore: currentScore)
        }
    }

    fileprivate(set) var gameStatus = GameStatus.notStarted {
        didSet {
            delegate?.notifyGameStatus()
        }
    }
}

extension FlappyViewModel: FlappyViewModelProtocol {

    // TODO: construct next question from database
    func getNextQuestion() -> FlappyQuestion {
        correctOptionIndex = 9
        return FlappyQuestion(title: "Match the answer", projectile: "2",
                              targets: ["1+1", "1+2", "1+3", "1+4"])
    }

    func landProjectile(in targetIndex: Int) {
        guard let correctOptionIndex = correctOptionIndex else {
            assertionFailure("correctOptionIndex not set")
            return
        }
        if targetIndex == correctOptionIndex {
            currentScore += Constants.Flappy.scoreIncrement
        } else {
            gameStatus = .endedWithLost
        }
    }

    func projectileFailedToLand() {
		gameStatus = .endedWithLost
    }

    var gameTitle: String {
    	return Constants.Flappy.gameTitle
    }

    var gameInstruction: String {
    	return Constants.Flappy.gameInstruction
    }

    func startGame() {
		gameStatus = .inProgress
    }
}
