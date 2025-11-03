struct RecentProjectArchive {
    private let storage: [String: Any]

    init(storage: [String: Any]) {
        self.storage = storage
    }

    var items: [RecentProjectArchiveItem] {
        let rawItems = storage["items"] as? [[String: Any]] ?? []
        return rawItems.map { RecentProjectArchiveItem(storage: $0) }
    }
}
