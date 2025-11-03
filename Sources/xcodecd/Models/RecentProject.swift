import Foundation

struct RecentProject: CustomStringConvertible, Equatable {
    let path: URL

    init?(url: URL) {
        guard !url.path(percentEncoded: false).isEmpty
        else { return nil }
        self.path = url
    }
}

extension RecentProject {
    private var projectFileExtensions: Set<String> {
        ["xcodeproj", "xcworkspace", "playground", "swiftpm", "package"]
    }

    var name: String {
        if projectFileExtensions.contains(path.pathExtension) {
            path.deletingPathExtension().lastPathComponent
        } else {
            path.lastPathComponent
        }
    }

    var description: String {
        let homePath = NSHomeDirectory()
        let path = path.path(percentEncoded: false)
        let modifiedPath: String
        if path.hasPrefix(homePath) {
            let startIndex = path.index(path.startIndex, offsetBy: homePath.count)
            modifiedPath = "~" + path[startIndex...]
        } else {
            modifiedPath = path
        }
        let displayPath: String
        let maxCounts = 40
        if modifiedPath.count <= maxCounts {
            displayPath = modifiedPath
        } else {
            let tail = modifiedPath.suffix(maxCounts)
            displayPath = "..." + tail
        }
        return "\(name) (\(displayPath))"
    }

    var destinationPath: URL {
        if projectFileExtensions.contains(path.pathExtension) {
            return path.deletingLastPathComponent()
        }

        if let resourceValues = try? path.resourceValues(forKeys: [.isDirectoryKey]),
           resourceValues.isDirectory ?? false {
            return path
        }
        
        return path.deletingLastPathComponent()
    }
}
