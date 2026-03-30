import SwiftUI
import SwiftData

struct EditLitterView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var litter: Litter

    @State private var name: String

    init(litter: Litter) {
        self.litter = litter
        _name = State(initialValue: litter.name)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Litter Name") {
                    TextField("e.g. Litter A", text: $name)
                }
            }
            .navigationTitle("Edit Litter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        litter.name = name.trimmingCharacters(in: .whitespaces)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
