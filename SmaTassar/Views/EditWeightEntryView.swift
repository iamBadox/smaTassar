import SwiftUI
import SwiftData

struct EditWeightEntryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(LanguageManager.self) private var lang
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
                Section(lang.t("date_time")) {
                    DatePicker("Date", selection: $date, displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()
                }
                Section(lang.t("weight_grams")) {
                    TextField(lang.t("weight_placeholder"), text: $weightText)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle(lang.t("edit_weight"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(lang.t("cancel")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(lang.t("save")) {
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
