import Foundation

enum LevelsError: LocalizedError {

    case duplicateLevelName(String)
    case noPhraseSelected

    var errorDescription: String {
        switch self {
        case .duplicateLevelName(let name):
            return "Duplicate level name: " + name
        case .noPhraseSelected:
            return "No phrase selected"
        }
    }
}
