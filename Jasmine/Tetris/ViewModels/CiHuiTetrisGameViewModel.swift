class CiHuiTetrisGameViewModel: TetrisGameViewModel {

    override var gameTitle: String {
        return String(format: GameConstants.Tetris.CiHui.gameTitle, gameData.name)
    }
    override var gameInstruction: String {
        return GameConstants.Tetris.CiHui.gameInstruction
    }
}
