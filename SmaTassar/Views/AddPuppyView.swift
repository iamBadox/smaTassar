import SwiftUI
import SwiftData

struct AddPuppyView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(LanguageManager.self) private var lang

    let litter: Litter

    @State private var name = ""
    @State private var collarColor: Color = .red
    @State private var sex = "Male"
    @State private var birthWeightText = ""
    @State private var birthDate = Date()

    var body: some View {
        NavigationStack {
            Form {
                Section(lang.t("name_optional")) {
                    TextField("e.g. Alva", text: $name)
                }
                Section(lang.t("collar_color")) {
                    ColorPicker(lang.t("pick_a_color"), selection: $collarColor)
                }
                Section(lang.t("sex")) {
                    Picker(lang.t("sex"), selection: $sex) {
                        Text(lang.t("male")).tag("Male")
                        Text(lang.t("female")).tag("Female")
                    }
                    .pickerStyle(.segmented)
                }
                Section(lang.t("birth_weight_grams")) {
                    TextField(lang.t("birth_weight_placeholder"), text: $birthWeightText)
                        .keyboardType(.decimalPad)
                }
                Section(lang.t("birth_date_time")) {
                    DatePicker("Birth Date", selection: $birthDate, displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()
                }
            }
            .navigationTitle(lang.t("add_puppy_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(lang.t("cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(lang.t("save")) {
                        savePuppy()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }

    private var isValid: Bool {
        guard let w = Double(birthWeightText), w > 0 else { return false }
        return true
    }

    private func savePuppy() {
        guard let weight = Double(birthWeightText) else { return }
        let puppy = Puppy(
            name: name.trimmingCharacters(in: .whitespaces).isEmpty ? nil : name.trimmingCharacters(in: .whitespaces),
            collarColor: collarColor.toHex(),
            sex: sex,
            birthWeight: weight,
            birthDate: birthDate
        )
        puppy.litter = litter
        litter.puppies.append(puppy)
        modelContext.insert(puppy)
        dismiss()
    }
}
