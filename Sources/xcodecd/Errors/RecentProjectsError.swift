import Foundation

enum RecentProjectsError: Error {
    /// The file of sfl is not found.
    case sflFileNotFound
    /// The recent-project list exists but could not be read or decoded.
    /// - Parameters:
    ///   - path: Absolute path to the sfl file that failed to load.
    ///   - underlying: The lower-level error raised by Foundation during the read/decode attempt.
    case unreadableFile(URL, underlying: Error)
    /// The recent-project list did not contain the expected keyed-archive structure.
    case unexpectedFormat
}

extension RecentProjectsError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .sflFileNotFound:
            return "Could not find sfl file"
        case let .unreadableFile(path, underlying):
            return "Failed to read \(path): \(underlying.localizedDescription)"
        case .unexpectedFormat:
            return "Unexpected file format: missing recent-project entries"
        }
    }
}
