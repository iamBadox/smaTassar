import SwiftUI
import SwiftData

struct AddWeightEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let puppy: Puppy

    @State private var date = Date()
    @State private var weightText = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Date & Time") {
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()
                }
                Section("Weight (grams)") {
                    TextField("e.g. 520", text: $weightText)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("Add Weight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                    }
                    .disabled(!isValid)
                }
            }
        }
    }

    private var isValid: Bool {
        guard let w = Double(weightText), w > 0 else { return false }
        return true
    }

    private func saveEntry() {
        guard let weight = Double(weightText) else { return }
        let entry = WeightEntry(weight: weight, date: date)
        entry.puppy = puppy
        puppy.weightEntries.append(entry)
        modelContext.insert(entry)
        dismiss()
    }
}
