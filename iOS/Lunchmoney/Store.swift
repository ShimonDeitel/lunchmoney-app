import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published var items: [LunchmoneyItem] = []
    @Published var isPro: Bool = false

    static let freeLimit = 40

    private let fileURL: URL = {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        return dir.appendingPathComponent("lunchmoney_items.json")
    }()

    init() {
        load()
        if items.isEmpty {
            items = Store.seedData()
            save()
        }
    }

    static func seedData() -> [LunchmoneyItem] {
        [
        LunchmoneyItem(place: "Cafe", cost: 12.5, broughtFromHome: false),
        LunchmoneyItem(place: "Home", cost: 0.0, broughtFromHome: true),
        LunchmoneyItem(place: "Deli", cost: 9.0, broughtFromHome: false)
        ]
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: LunchmoneyItem) {
        guard canAddMore else { return }
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: LunchmoneyItem) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: LunchmoneyItem) {
        items.removeAll { $0.id == item.id }
        save()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else { return }
        if let decoded = try? JSONDecoder().decode([LunchmoneyItem].self, from: data) {
            items = decoded
        }
    }

    func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
