import Foundation

enum RecentProjectsError: Error {
    /// The `com.apple.dt.xcode.sfl4` file was not found at the expected absolute path.
    /// - Parameter path: Absolute path that was checked for the recent-project list.
    case fileNotFound(URL)
    /// The recent-project list exists but could not be read or decoded.
    /// - Parameters:
    ///   - path: Absolute path to the `sfl4` file that failed to load.
    ///   - underlying: The lower-level error raised by Foundation during the read/decode attempt.
    case unreadableFile(URL, underlying: Error)
    /// The recent-project list did not contain the expected keyed-archive structure.
    case unexpectedFormat
}

extension RecentProjectsError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .fileNotFound(path):
            return "Could not find recent-project list at \(path)"
        case let .unreadableFile(path, underlying):
            return "Failed to read \(path): \(underlying.localizedDescription)"
        case .unexpectedFormat:
            return "Unexpected file format: missing recent-project entries"
        }
    }
}
