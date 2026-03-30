import SwiftUI
import SwiftData

struct EditPuppyView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var puppy: Puppy

    @State private var name: String
    @State private var collarColor: Color
    @State private var sex: String
    @State private var birthWeightText: String
    @State private var birthDate: Date

    let sexOptions = ["Male", "Female"]

    init(puppy: Puppy) {
        self.puppy = puppy
        _name = State(initialValue: puppy.name ?? "")
        _collarColor = State(initialValue: Color(hex: puppy.collarColor))
        _sex = State(initialValue: puppy.sex)
        _birthWeightText = State(initialValue: String(format: "%g", puppy.birthWeight))
        _birthDate = State(initialValue: puppy.birthDate)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Name (optional)") {
                    TextField("e.g. Bella", text: $name)
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
            .navigationTitle("Edit Puppy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { savePuppy() }
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
        puppy.name = name.trimmingCharacters(in: .whitespaces).isEmpty ? nil : name.trimmingCharacters(in: .whitespaces)
        puppy.collarColor = collarColor.toHex()
        puppy.sex = sex
        puppy.birthWeight = weight
        puppy.birthDate = birthDate
        dismiss()
    }
}
