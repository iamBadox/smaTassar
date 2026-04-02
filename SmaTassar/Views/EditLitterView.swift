import SwiftUI
import SwiftData

struct EditLitterView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(LanguageManager.self) private var lang
    @Bindable var litter: Litter

    @State private var name: String

    init(litter: Litter) {
        self.litter = litter
        _name = State(initialValue: litter.name)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(lang.t("litter_name")) {
                    TextField(lang.t("litter_name_placeholder"), text: $name)
                }
            }
            .navigationTitle(lang.t("edit_litter"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(lang.t("cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(lang.t("save")) {
                        litter.name = name.trimmingCharacters(in: .whitespaces)
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}
