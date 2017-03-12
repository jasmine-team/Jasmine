import Foundation

/// Tile Model to store word and position on the grid

class TetrisTile {

    let word: Character
    var indexPath: IndexPath

    init(word: Character, indexPath: IndexPath) {
        self.word = word
        self.indexPath = indexPath
    }

}
