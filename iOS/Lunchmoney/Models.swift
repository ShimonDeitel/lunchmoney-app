import Foundation

struct LunchmoneyItem: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var place: String
    var cost: Double
    var broughtFromHome: Bool
}
