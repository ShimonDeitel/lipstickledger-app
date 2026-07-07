import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var items: [Product] = []
    @Published var isPro: Bool = false

    static let freeLimit = 30

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("lipstickledger", isDirectory: true)
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("items.json")
        load()
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: Product) {
        guard canAddMore else { return }
        items.append(item)
        save()
    }

    func update(_ item: Product) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Product) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([Product].self, from: data) {
            items = decoded
        } else {
            items = Store.seedData
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    static var seedData: [Product] {
        [
        Product(id: UUID(), title: "Ruby Woo", shade: "Matte Red", openedOn: ISO8601DateFormatter().date(from: "2026-01-01T00:00:00Z") ?? Date(), notes: "Classic red"),
        Product(id: UUID(), title: "Velvet Teddy", shade: "Nude", openedOn: ISO8601DateFormatter().date(from: "2026-02-01T00:00:00Z") ?? Date(), notes: "Everyday"),
        Product(id: UUID(), title: "Fenty Gloss", shade: "Fuchsia", openedOn: ISO8601DateFormatter().date(from: "2026-03-01T00:00:00Z") ?? Date(), notes: "Summer")
        ]
    }
}
