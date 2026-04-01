import SwiftUI
import SwiftData
import Charts

struct LitterChartsView: View {
    @Environment(\.dismiss) private var dismiss
    let litter: Litter

    struct ChartPoint: Identifiable {
        let id = UUID()
        let puppyID: UUID
        let collarColor: String
        let date: Date
        let weight: Double
    }

    struct PuppyStats {
        let puppy: Puppy
        let birthWeight: Double
        let latestWeight: Double
        let previousWeight: Double?
        let latestDate: Date

        var sinceBirthPercent: Double {
            (latestWeight - birthWeight) / birthWeight * 100
        }

        var lastIntervalPercent: Double? {
            guard let prev = previousWeight else { return nil }
            return (latestWeight - prev) / prev * 100
        }

        var displayName: String {
            puppy.name ?? "\(puppy.sex == "Male" ? "♂" : "♀")"
        }
    }

    private var chartData: [ChartPoint] {
        var points: [ChartPoint] = []
        for puppy in litter.puppies {
            points.append(ChartPoint(
                puppyID: puppy.id,
                collarColor: puppy.collarColor,
                date: puppy.birthDate,
                weight: puppy.birthWeight
            ))
            for entry in puppy.weightEntries.sorted(by: { $0.date < $1.date }) {
                points.append(ChartPoint(
                    puppyID: puppy.id,
                    collarColor: puppy.collarColor,
                    date: entry.date,
                    weight: entry.weight
                ))
            }
        }
        return points
    }

    private var puppyGroups: [(id: UUID, color: String)] {
        litter.puppies.map { (id: $0.id, color: $0.collarColor) }
    }

    private var xDomain: ClosedRange<Date> {
        let allDates = chartData.map { $0.date }
        let earliest = allDates.min() ?? Date()
        let latest = allDates.max() ?? Date()
        return earliest...latest
    }

    private var puppyStats: [PuppyStats] {
        litter.puppies.compactMap { puppy in
            let sorted = puppy.weightEntries.sorted { $0.date < $1.date }
            guard let latest = sorted.last else { return nil }
            let previous = sorted.dropLast().last
            return PuppyStats(
                puppy: puppy,
                birthWeight: puppy.birthWeight,
                latestWeight: latest.weight,
                previousWeight: previous?.weight,
                latestDate: latest.date
            )
        }
    }

    private let percentFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.maximumFractionDigits = 1
        f.minimumFractionDigits = 1
        f.positivePrefix = "+"
        return f
    }()

    private func formatPercent(_ value: Double) -> String {
        percentFormatter.string(from: NSNumber(value: value)) ?? "\(value)%"
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if litter.puppies.isEmpty {
                        ContentUnavailableView(
                            "No Puppies",
                            systemImage: "pawprint",
                            description: Text("Add puppies to see charts.")
                        )
                    } else {
                        Chart {
                            ForEach(puppyGroups, id: \.id) { group in
                                let points = chartData.filter { $0.puppyID == group.id }.sorted { $0.date < $1.date }
                                ForEach(points) { point in
                                    LineMark(
                                        x: .value("Date", point.date),
                                        y: .value("Weight (g)", point.weight)
                                    )
                                    .foregroundStyle(by: .value("Puppy", group.id.uuidString))
                                    .symbol(Circle())
                                }
                            }
                        }
                        .chartForegroundStyleScale(
                            domain: puppyGroups.map { $0.id.uuidString },
                            range: puppyGroups.map { Color(hex: $0.color) }
                        )
                        .chartLegend(.hidden)
                        .chartXScale(domain: xDomain)
                        .frame(height: 320)
                        .padding()

                        // Weight gain stats
                        if !puppyStats.isEmpty {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Weight Gain")
                                    .font(.headline)
                                    .padding(.horizontal)

                                ForEach(puppyStats, id: \.puppy.id) { stats in
                                    HStack(spacing: 12) {
                                        Circle()
                                            .fill(Color(hex: stats.puppy.collarColor))
                                            .frame(width: 36, height: 36)
                                            .overlay(Circle().stroke(Color.secondary.opacity(0.3), lineWidth: 1))
                                            .overlay(
                                                Text(stats.puppy.sex == "Male" ? "♂" : "♀")
                                                    .font(.system(size: 16, weight: .bold))
                                                    .foregroundStyle(.white.opacity(0.9))
                                            )

                                        VStack(alignment: .leading, spacing: 2) {
                                            Text(stats.displayName)
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                            Text("\(Int(stats.birthWeight))g → \(Int(stats.latestWeight))g")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }

                                        Spacer()

                                        VStack(alignment: .trailing, spacing: 4) {
                                            HStack(spacing: 4) {
                                                Image(systemName: "arrow.up.right")
                                                    .font(.caption2)
                                                Text("Since birth")
                                                    .font(.caption)
                                            }
                                            .foregroundStyle(.secondary)
                                            Text("\(formatPercent(stats.sinceBirthPercent))%")
                                                .font(.subheadline)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(stats.sinceBirthPercent >= 0 ? .green : .red)

                                            if let interval = stats.lastIntervalPercent {
                                                HStack(spacing: 4) {
                                                    Image(systemName: "clock")
                                                        .font(.caption2)
                                                    Text("Last update")
                                                        .font(.caption)
                                                }
                                                .foregroundStyle(.secondary)
                                                Text("\(formatPercent(interval))%")
                                                    .font(.subheadline)
                                                    .fontWeight(.semibold)
                                                    .foregroundStyle(interval >= 0 ? .green : .red)
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(Color(.secondarySystemBackground))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Litter Charts")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
