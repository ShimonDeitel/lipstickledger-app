import Foundation

struct Product: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var shade: String
    var openedOn: Date
    var notes: String
}
