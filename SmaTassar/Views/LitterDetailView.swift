import SwiftUI
import SwiftData

struct LitterDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var litter: Litter
    @State private var showingAddPuppy = false
    @State private var showingCharts = false

    var body: some View {
        Group {
            if litter.puppies.isEmpty {
                ContentUnavailableView(
                    "No Puppies Yet",
                    systemImage: "pawprint",
                    description: Text("Tap \"Add Puppy\" to get started.")
                )
            } else {
                List(litter.puppies) { puppy in
                    NavigationLink(destination: PuppyDetailView(puppy: puppy)) {
                        PuppyRowView(puppy: puppy)
                    }
                }
            }
        }
        .navigationTitle(litter.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button {
                        showingAddPuppy = true
                    } label: {
                        Label("Add Puppy", systemImage: "plus")
                    }
                    Button {
                        withAnimation {
                            litter.isComplete.toggle()
                        }
                    } label: {
                        Label(
                            litter.isComplete ? "Reopen Litter" : "Mark as Complete",
                            systemImage: litter.isComplete ? "arrow.uturn.backward" : "checkmark.seal"
                        )
                    }
                    Button {
                        showingCharts = true
                    } label: {
                        Label("View Charts", systemImage: "chart.line.uptrend.xyaxis")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingAddPuppy) {
            AddPuppyView(litter: litter)
        }
        .sheet(isPresented: $showingCharts) {
            LitterChartsView(litter: litter)
        }
        .safeAreaInset(edge: .bottom) {
            if !litter.puppies.isEmpty {
                Button {
                    showingCharts = true
                } label: {
                    Label("View Litter Charts", systemImage: "chart.line.uptrend.xyaxis")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "#8B6914"))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
                .background(.ultraThinMaterial)
            }
        }
    }
}

struct PuppyRowView: View {
    let puppy: Puppy

    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(hex: puppy.collarColor))
                .frame(width: 28, height: 28)
                .overlay(Circle().stroke(Color.secondary.opacity(0.3), lineWidth: 1))

            VStack(alignment: .leading, spacing: 2) {
                if let name = puppy.name {
                    Text(name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                HStack {
                    Image(systemName: puppy.sex == "Male" ? "arrow.up.circle" : "arrow.down.circle")
                        .foregroundStyle(puppy.sex == "Male" ? .blue : .pink)
                    Text(puppy.sex)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                Text("Born: \(dateFormatter.string(from: puppy.birthDate))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Birth weight: \(Int(puppy.birthWeight))g")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
