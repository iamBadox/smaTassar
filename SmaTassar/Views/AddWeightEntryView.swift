import SwiftUI
import SwiftData

struct AddWeightEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(LanguageManager.self) private var lang

    let puppy: Puppy

    @State private var date = Date()
    @State private var weightText = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(lang.t("date_time")) {
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()
                }
                Section(lang.t("weight_grams")) {
                    TextField(lang.t("weight_placeholder"), text: $weightText)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle(lang.t("add_weight"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(lang.t("cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(lang.t("save")) {
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
