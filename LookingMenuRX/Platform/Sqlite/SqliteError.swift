import Foundation

enum SqliteError: Error {
    case addFail
    case deleteFail
    case readFail
}

extension SqliteError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .addFail:
            return "Cant add this item. Try again later"
        case .deleteFail:
            return "Cant delete this item. Try again later"
        case .readFail:
            return "Cant read items"
        }
    }
}
