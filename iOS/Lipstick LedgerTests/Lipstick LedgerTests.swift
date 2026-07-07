import XCTest
@testable import Lipstick Ledger

@MainActor
final class Lipstick LedgerTests: XCTestCase {
    func testSeedDataBelowFreeLimit() {
        XCTAssertLessThan(Store.seedData.count, Store.freeLimit)
    }

    func testAddIncreasesCount() {
        let store = Store()
        let before = store.items.count
        let item = Product(id: UUID(), title: String = "", shade: String = "", openedOn: Date = Date(), notes: String = "")
        store.add(item)
        XCTAssertEqual(store.items.count, before + 1)
    }

    func testDeleteDecreasesCount() {
        let store = Store()
        let item = Product(id: UUID(), title: String = "", shade: String = "", openedOn: Date = Date(), notes: String = "")
        store.add(item)
        let before = store.items.count
        store.delete(item)
        XCTAssertEqual(store.items.count, before - 1)
    }

    func testCanAddMoreWhenBelowLimit() {
        let store = Store()
        store.isPro = false
        XCTAssertTrue(store.canAddMore)
    }

    func testCannotAddMoreAtFreeLimitWithoutPro() {
        let store = Store()
        store.isPro = false
        for _ in 0..<(Store.freeLimit) {
            store.add(Product(id: UUID(), title: String = "", shade: String = "", openedOn: Date = Date(), notes: String = ""))
        }
        XCTAssertFalse(store.canAddMore)
    }

    func testProBypassesLimit() {
        let store = Store()
        store.isPro = true
        for _ in 0..<(Store.freeLimit + 5) {
            store.add(Product(id: UUID(), title: String = "", shade: String = "", openedOn: Date = Date(), notes: String = ""))
        }
        XCTAssertTrue(store.canAddMore)
    }

    func testUpdateModifiesItem() {
        let store = Store()
        var item = Product(id: UUID(), title: String = "", shade: String = "", openedOn: Date = Date(), notes: String = "")
        store.add(item)
        item.title = "Updated"
        store.update(item)
        XCTAssertEqual(store.items.first(where: { $0.id == item.id })?.title, "Updated")
    }

    func testDeleteAtOffsets() {
        let store = Store()
        let item = Product(id: UUID(), title: String = "", shade: String = "", openedOn: Date = Date(), notes: String = "")
        store.add(item)
        if let idx = store.items.firstIndex(where: { $0.id == item.id }) {
            store.delete(at: IndexSet(integer: idx))
        }
        XCTAssertFalse(store.items.contains(where: { $0.id == item.id }))
    }
}
