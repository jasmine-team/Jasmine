import Foundation

protocol TetrisViewDelegate: class {

    /// Updates the position and content of the moving tile
    func updateMovingTile(_ movingTile: TetrisTile)

    /// Settle the moving tile on the grid after it has collided
    func placeMovingTile()

    /// Destroys the tile on the grid after phrase is matched
    func destroyTile(at indexPath: IndexPath)

    /// Shift the tile down by 1 row as the tile below is destroyed
    func shiftTileDown(at indexPath: IndexPath)

}

/// The game engine for Tetris

class TetrisEngine {

    private weak var viewDelegate: TetrisViewDelegate?
    private var tetrisGrid = TetrisGrid()
    private var movingTile: TetrisTile?

    init(viewDelegate: TetrisViewDelegate) {
        self.viewDelegate = viewDelegate
        Timer.scheduledTimer(withTimeInterval: Constants.Tetris.updateInterval,
                             repeats: true) { _ in
            self.updateState()
        }
    }

    /// Moves the moving tile towards the indexPath (left or right) by 1 unit
    func moveTile(towards indexPath: IndexPath) {
        guard let movingTile = movingTile else {
            return
        }
        let currentCol = movingTile.indexPath.row
        let tappedCol = indexPath.row
        guard currentCol != tappedCol else {
            return
        }
        let newRow = movingTile.indexPath.row + (currentCol < tappedCol ? 1 : -1)
        guard !tetrisGrid.hasTile(at: IndexPath(row: newRow, section: movingTile.indexPath.section)) else {
            return
        }
        movingTile.indexPath.row = newRow
        viewDelegate?.updateMovingTile(movingTile)
    }

    /// Checks if moving tile has collided and updates its position.
    /// Shifting of moving tile downwards must be done after checking if tile collided
    /// to avoid tile crashing into existing tile due to movement by gestures
    @objc
    private func updateState() {
        if hasTileCollided() {
            if let destroyedIndexes = getDestroyedIndexes() {
                shiftDownTiles(destroyedIndexes)
            }
        }
        updateMovingTile()
    }

    /// Updates the position of the moving tile. 
    /// Creates a new moving tile it doesn't exist (when first initialized or after a collision)
    private func updateMovingTile() {
        if let movingTile = movingTile {
            movingTile.indexPath = getNextPosition(movingTile.indexPath)
        } else {
            let randCol = Int(arc4random_uniform(UInt32(Constants.Tetris.columns)))
            movingTile = TetrisTile(word: getRandomWord(),
                                          indexPath: IndexPath(row: randCol, section: 0))
        }
        guard let movingTile = movingTile else {
            assert(false, "Failed to create movingTile")
        }
        viewDelegate?.updateMovingTile(movingTile)
    }

    /// Checks if the moving tile reached bottom or there is a tile below it
    /// if true, settle the tile on the grid
    private func hasTileCollided() -> Bool {
        guard let movingTile = movingTile else {
            return false
        }

        let nextPosition = getNextPosition(movingTile.indexPath)
        guard nextPosition.section == Constants.Tetris.rows ||
              tetrisGrid.hasTile(at: nextPosition) else {
            return false
        }

        tetrisGrid.add(movingTile)
        viewDelegate?.placeMovingTile()
        self.movingTile = nil
        return true
    }

    private func getDestroyedIndexes() -> Set<IndexPath>? {
        if let destroyedIndexes = getDestroyedIndexes(byRow: true) {
            return destroyedIndexes
        } else {
            return getDestroyedIndexes(byRow: false)
        }
    }

    /// Checkes for and returns indexes of matching phrase, row/col-wise as specify by byRow
    /// Concatenate the words row by row or col by col to check if a phrase is contained in them
    private func getDestroyedIndexes(byRow: Bool) -> Set<IndexPath>? {
        var destroyedIndexes: Set<IndexPath> = []
        let maxIndex = byRow ? Constants.Tetris.rows : Constants.Tetris.columns
        for index in 0..<maxIndex {
            var line: [Character] = []
            if byRow {
                for col in 0..<Constants.Tetris.columns {
                    line.append(getWord(row: col, section: index))
                }
            } else {
                for row in 0..<Constants.Tetris.rows {
                    line.append(getWord(row: index, section: row))
                }
            }

            guard let range = getValidPhraseRange(line) else {
                continue
            }

            for i in range {
                let indexPath = byRow ? IndexPath(row: i, section: index) :
                                        IndexPath(row: index, section: i)
                tetrisGrid.remove(at: indexPath)
                if byRow {
                    destroyedIndexes.insert(indexPath)
                }
                viewDelegate?.destroyTile(at: indexPath)
            }
            return byRow ? destroyedIndexes : nil
        }
        return nil
    }

    /// Gets the word at the row and section 
    /// returns " " if no word is present so that phrases separated by gaps don't get matched
    private func getWord(row: Int, section: Int) -> Character {
        return tetrisGrid.get(at: IndexPath(row: row, section: section))?.word ?? " "
    }

    /// Shifts all the tiles above the indexes 1 cell down
    private func shiftDownTiles(_ indexes: Set<IndexPath>) {
        for indexPath in indexes {
            for section in (0..<indexPath.section).reversed() {
                let indexPath = IndexPath(row: indexPath.row, section: section)
                guard let tile = tetrisGrid.get(at: indexPath) else {
                    break
                }
                tetrisGrid.remove(at: indexPath)
                tile.indexPath.section += 1
                tetrisGrid.add(tile)
                viewDelegate?.shiftTileDown(at: indexPath)
            }
        }
    }

    // TODO: fetch from database to match valid phrase
    private func getValidPhraseRange(_ line: [Character]) -> CountableRange<Int>? {
        let phrases = ["先发制人"]
        for phrase in phrases {
            let phraseLen = phrase.characters.count
            for i in 0...line.count - phraseLen {
                let range = i..<i + phraseLen
                if String(line[range]) == phrase {
                    return range
                }
            }
        }
        return nil
    }

    private func getNextPosition(_ indexPath: IndexPath) -> IndexPath {
        return IndexPath(row: indexPath.row, section: indexPath.section + 1)
    }

    // TODO: generate from database, base on existing grid
    private func getRandomWord() -> Character {
        let words = "先发制人"
        return words[words.index(words.startIndex,
                                 offsetBy: Int(arc4random_uniform(UInt32(words.characters.count))))]
    }

}
