import SwiftUI
import SwiftData

struct AddLitterView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Litter Name") {
                    TextField("e.g. Litter A", text: $name)
                }
            }
            .navigationTitle("New Litter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveLitter()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }

    private func saveLitter() {
        let litter = Litter(name: name.trimmingCharacters(in: .whitespaces))
        modelContext.insert(litter)
        dismiss()
    }
}
