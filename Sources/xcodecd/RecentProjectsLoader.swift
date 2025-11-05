import Foundation

struct RecentProjectsLoader {
    private let fileManager = FileManager.default

    func load() throws -> [RecentProject] {
        let recentProjectArchive = try resolveRecentProjectArchive()
        let archiveItems = recentProjectArchive.items

        return archiveItems.compactMap { item -> RecentProject? in
            var stale = false
            guard let bookmark = item.bookmark,
                  let url = try? URL(resolvingBookmarkData: bookmark, options: [.withoutUI], relativeTo: nil, bookmarkDataIsStale: &stale) else {
                return nil
            }

            return RecentProject(url: url)
        }
    }

    private func resolveRecentProjectArchive() throws -> RecentProjectArchive {
        let listURL = try resolveRecentListURL()
        let unarchiver = try NSKeyedUnarchiver.makeForReading(at: listURL)

        guard let root = try unarchiver.decodeTopLevelObject(forKey: NSKeyedArchiveRootObjectKey) as? [String: Any]
        else { throw RecentProjectsError.unexpectedFormat }

        return RecentProjectArchive(storage: root)
    }

    private func resolveRecentListURL() throws -> URL {
        let sfl4Path = "Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.apple.dt.xcode.sfl4"
        let sfl3Path = "Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.apple.dt.xcode.sfl3"

        let sfl4URL = fileManager.homeDirectoryForCurrentUser.appendingPathComponent(sfl4Path, isDirectory: false)
        let sfl3URL = fileManager.homeDirectoryForCurrentUser.appendingPathComponent(sfl3Path, isDirectory: false)

        // Try sfl4 first (for macOS 26+)
        if fileManager.fileExists(atPath: sfl4URL.path(percentEncoded: false)) {
            return sfl4URL
        } else if fileManager.fileExists(atPath: sfl3URL.path(percentEncoded: false)) {
            return sfl3URL
        } else {
            throw RecentProjectsError.sflFileNotFound
        }
    }
}

private extension NSKeyedUnarchiver {
    static func makeForReading(at url: URL) throws(RecentProjectsError) -> NSKeyedUnarchiver {
        let data = try Data.contents(of: url)
        do {
            let unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
            unarchiver.requiresSecureCoding = false
            return unarchiver
        } catch {
            throw RecentProjectsError.unreadableFile(url, underlying: error)
        }
    }
}

extension Data {
    fileprivate static func contents(of url: URL) throws(RecentProjectsError) -> Data {
        do {
            return try Data(contentsOf: url)
        } catch {
            throw RecentProjectsError.unreadableFile(url, underlying: error)
        }
    }
}
