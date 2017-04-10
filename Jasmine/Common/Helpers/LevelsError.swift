import Foundation

enum LevelsError: LocalizedError {

    case duplicateLevelName(String)

    var errorDescription: String? {
        switch self {
        case .duplicateLevelName(let name):
            return "Duplicate level name: " + name
        }
    }
}
