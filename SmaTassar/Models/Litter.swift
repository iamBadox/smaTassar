import Foundation
import SwiftData

@Model
final class Litter {
    var id: UUID
    var name: String
    var dateCreated: Date
    var isComplete: Bool
    @Relationship(deleteRule: .cascade) var puppies: [Puppy]

    init(id: UUID = UUID(), name: String, dateCreated: Date = Date(), isComplete: Bool = false) {
        self.id = id
        self.name = name
        self.dateCreated = dateCreated
        self.isComplete = isComplete
        self.puppies = []
    }
}
