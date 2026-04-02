import SwiftUI
import SwiftData

struct AddLitterView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(LanguageManager.self) private var lang
    @State private var name = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(lang.t("litter_name")) {
                    TextField(lang.t("litter_name_placeholder"), text: $name)
                }
            }
            .navigationTitle(lang.t("new_litter"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(lang.t("cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(lang.t("save")) {
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
