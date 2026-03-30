import SwiftUI
import SwiftData

struct AddPuppyView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let litter: Litter

    @State private var name = ""
    @State private var collarColor: Color = .red
    @State private var sex = "Male"
    @State private var birthWeightText = ""
    @State private var birthDate = Date()

    let sexOptions = ["Male", "Female"]

    var body: some View {
        NavigationStack {
            Form {
                Section("Name (optional)") {
                    TextField("e.g. Alva", text: $name)
                }
                Section("Collar Color") {
                    ColorPicker("Pick a color", selection: $collarColor)
                }
                Section("Sex") {
                    Picker("Sex", selection: $sex) {
                        ForEach(sexOptions, id: \.self) { Text($0) }
                    }
                    .pickerStyle(.segmented)
                }
                Section("Birth Weight (grams)") {
                    TextField("e.g. 450", text: $birthWeightText)
                        .keyboardType(.decimalPad)
                }
                Section("Birth Date & Time") {
                    DatePicker("Birth Date", selection: $birthDate, displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()
                }
            }
            .navigationTitle("Add Puppy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
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
