import Foundation

struct RecentProjectsLoader {
    private let fileManager = FileManager.default
    private let relativePath = "Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.apple.dt.xcode.sfl4"

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
        let listURL = fileManager.homeDirectoryForCurrentUser.appendingPathComponent(relativePath, isDirectory: false)

        guard fileManager.fileExists(atPath: listURL.path(percentEncoded: false)) else {
            throw RecentProjectsError.fileNotFound(listURL)
        }

        let data: Data
        do {
            data = try Data(contentsOf: listURL)
        } catch {
            throw RecentProjectsError.unreadableFile(listURL, underlying: error)
        }

        let unarchiver: NSKeyedUnarchiver
        do {
            unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
        } catch {
            throw RecentProjectsError.unreadableFile(listURL, underlying: error)
        }
        unarchiver.requiresSecureCoding = false

        guard let root = try unarchiver.decodeTopLevelObject(forKey: NSKeyedArchiveRootObjectKey) as? [String: Any]
        else {
            throw RecentProjectsError.unexpectedFormat
        }
        return RecentProjectArchive(storage: root)
    }
}
