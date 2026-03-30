import Foundation
import SwiftData

@Model
final class WeightEntry {
    var id: UUID
    var weight: Double
    var date: Date
    var puppy: Puppy?

    init(id: UUID = UUID(), weight: Double, date: Date = Date()) {
        self.id = id
        self.weight = weight
        self.date = date
    }
}
