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
                        .frame(height: 320)
                        .padding()

                        // Legend
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Puppies")
                                .font(.headline)
                                .padding(.horizontal)
                            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))], alignment: .leading) {
                                ForEach(puppyGroups, id: \.id) { group in
                                    Circle()
                                        .fill(Color(hex: group.color))
                                        .frame(width: 24, height: 24)
                                        .overlay(Circle().stroke(Color.secondary.opacity(0.3), lineWidth: 1))
                                }
                            }
                            .padding(.horizontal)
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
