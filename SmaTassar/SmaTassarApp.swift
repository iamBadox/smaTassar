import SwiftUI
import SwiftData

@main
struct SmaTassarApp: App {
    var body: some Scene {
        WindowGroup {
            LittersListView()
        }
        .modelContainer(for: [Litter.self, Puppy.self, WeightEntry.self])
    }
}
