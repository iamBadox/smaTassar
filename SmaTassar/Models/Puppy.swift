import Foundation
import SwiftData

@Model
final class Puppy {
    var id: UUID
    var name: String?
    var collarColor: String
    var sex: String
    var birthWeight: Double
    var birthDate: Date
    @Relationship(deleteRule: .cascade) var weightEntries: [WeightEntry]
    var litter: Litter?

    init(id: UUID = UUID(), name: String? = nil, collarColor: String, sex: String, birthWeight: Double, birthDate: Date) {
        self.id = id
        self.name = name
        self.collarColor = collarColor
        self.sex = sex
        self.birthWeight = birthWeight
        self.birthDate = birthDate
        self.weightEntries = []
    }
}
