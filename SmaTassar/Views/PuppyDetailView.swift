import SwiftUI
import SwiftData
import Charts

struct PuppyDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var puppy: Puppy
    @State private var showingAddWeight = false

    private var chartData: [(date: Date, weight: Double)] {
        var points: [(date: Date, weight: Double)] = [(date: puppy.birthDate, weight: puppy.birthWeight)]
        let sorted = puppy.weightEntries.sorted { $0.date < $1.date }
        points += sorted.map { (date: $0.date, weight: $0.weight) }
        return points
    }

    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }()

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Puppy info card
                HStack(spacing: 16) {
                    Circle()
                        .fill(Color(hex: puppy.collarColor))
                        .frame(width: 48, height: 48)
                        .overlay(Circle().stroke(Color.secondary.opacity(0.3), lineWidth: 1))

                    VStack(alignment: .leading, spacing: 4) {
                        if let name = puppy.name {
                            Text(name)
                                .font(.headline)
                        }
                        Label(puppy.sex, systemImage: puppy.sex == "Male" ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                            .foregroundStyle(puppy.sex == "Male" ? .blue : .pink)
                            .font(.headline)
                        Text("Born: \(dateFormatter.string(from: puppy.birthDate))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("Birth weight: \(Int(puppy.birthWeight))g")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                // Weight chart
                if chartData.count > 1 {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Weight Over Time")
                            .font(.headline)
                            .padding(.horizontal)

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
                        .padding(.horizontal)
                    }
                } else {
                    Text("Add weight entries to see the chart.")
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)
                }

                // Weight entries list
                VStack(alignment: .leading, spacing: 8) {
                    Text("Weight Entries")
                        .font(.headline)
                        .padding(.horizontal)

                    // Birth weight row
                    HStack {
                        Text(dateFormatter.string(from: puppy.birthDate))
                            .font(.subheadline)
                        Spacer()
                        Text("\(Int(puppy.birthWeight))g")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text("(birth)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal)

                    ForEach(puppy.weightEntries.sorted { $0.date < $1.date }) { entry in
                        HStack {
                            Text(dateFormatter.string(from: entry.date))
                                .font(.subheadline)
                            Spacer()
                            Text("\(Int(entry.weight))g")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
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
    }
}
