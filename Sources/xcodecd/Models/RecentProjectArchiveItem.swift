import Foundation

struct RecentProjectArchiveItem {
    private let storage: [String: Any]

    init(storage: [String: Any]) {
        self.storage = storage
    }

    var bookmark: Data? {
        storage["Bookmark"] as? Data
    }
}
