import SwiftUI
import SwiftData

@main
struct SmaTassarApp: App {
    @State private var languageManager = LanguageManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(languageManager)
        }
        .modelContainer(for: [Litter.self, Puppy.self, WeightEntry.self])
    }
}
