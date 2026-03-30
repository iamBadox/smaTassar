import SwiftUI
import SwiftData

struct EditWeightEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var entry: WeightEntry

    @State private var date: Date
    @State private var weightText: String

    init(entry: WeightEntry) {
        self.entry = entry
        _date = State(initialValue: entry.date)
        _weightText = State(initialValue: String(format: "%g", entry.weight))
    }

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
            .navigationTitle("Edit Weight")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let weight = Double(weightText), weight > 0 else { return }
                        entry.weight = weight
                        entry.date = date
                        dismiss()
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
}
