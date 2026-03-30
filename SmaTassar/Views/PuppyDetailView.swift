import SwiftUI
import SwiftData
import Charts

struct PuppyDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var puppy: Puppy
    @State private var showingAddWeight = false
    @State private var entryToEdit: WeightEntry?

    private var sortedEntries: [WeightEntry] {
        puppy.weightEntries.sorted { $0.date < $1.date }
    }

    private var chartData: [(date: Date, weight: Double)] {
        var points: [(date: Date, weight: Double)] = [(date: puppy.birthDate, weight: puppy.birthWeight)]
        points += sortedEntries.map { (date: $0.date, weight: $0.weight) }
        return points
    }

    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }()

    var body: some View {
        List {
            // Puppy info card
            Section {
                HStack(spacing: 16) {
                    Circle()
                        .fill(Color(hex: puppy.collarColor))
                        .frame(width: 48, height: 48)
                        .overlay(Circle().stroke(Color.secondary.opacity(0.3), lineWidth: 1))

                    VStack(alignment: .leading, spacing: 4) {
                        if let name = puppy.name {
                            Text(name).font(.headline)
                        }
                        Label(puppy.sex, systemImage: puppy.sex == "Male" ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                            .foregroundStyle(puppy.sex == "Male" ? .blue : .pink)
                            .font(puppy.name == nil ? .headline : .subheadline)
                        Text("Born: \(dateFormatter.string(from: puppy.birthDate))")
                            .font(.subheadline).foregroundStyle(.secondary)
                        Text("Birth weight: \(Int(puppy.birthWeight))g")
                            .font(.subheadline).foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }

            // Growth chart
            if chartData.count > 1 {
                Section("Weight Over Time") {
                    Chart(chartData, id: \.date) { point in
                        LineMark(
                            x: .value("Date", point.date),
                            y: .value("Weight (g)", point.weight)
                        )
                        .foregroundStyle(Color(hex: puppy.collarColor))
                        PointMark(
                            x: .value("Date", point.date),
                            y: .value("Weight (g)", point.weight)
                        )
                        .foregroundStyle(Color(hex: puppy.collarColor))
                    }
                    .frame(height: 220)
                    .padding(.vertical, 8)
                }
            }

            // Weight entries
            Section("Weight Entries") {
                // Birth weight row (not editable/deletable)
                HStack {
                    Text(dateFormatter.string(from: puppy.birthDate))
                        .font(.subheadline)
                    Spacer()
                    Text("\(Int(puppy.birthWeight))g")
                        .font(.subheadline).fontWeight(.medium)
                    Text("(birth)")
                        .font(.caption).foregroundStyle(.secondary)
                }

                ForEach(sortedEntries) { entry in
                    HStack {
                        Text(dateFormatter.string(from: entry.date))
                            .font(.subheadline)
                        Spacer()
                        Text("\(Int(entry.weight))g")
                            .font(.subheadline).fontWeight(.medium)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            modelContext.delete(entry)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            entryToEdit = entry
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.orange)
                    }
                }

                if puppy.weightEntries.isEmpty {
                    Text("No weight updates yet.")
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                }
            }
        }
        .navigationTitle(puppy.name ?? "Puppy Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showingAddWeight = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddWeight) {
            AddWeightEntryView(puppy: puppy)
        }
        .sheet(item: $entryToEdit) { entry in
            EditWeightEntryView(entry: entry)
        }
    }
}

