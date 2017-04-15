class ChengYuTetrisGameViewModel: TetrisGameViewModel {

    override var gameTitle: String {
        return String(format: GameConstants.Tetris.ChengYu.gameTitle, gameData.name)
    }
    override var gameInstruction: String {
        return GameConstants.Tetris.ChengYu.gameInstruction
    }
}
