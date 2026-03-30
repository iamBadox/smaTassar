import SwiftUI
import SwiftData

struct LittersListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Litter.dateCreated, order: .reverse) private var litters: [Litter]
    @State private var showingAddLitter = false

    var body: some View {
        NavigationStack {
            Group {
                if litters.isEmpty {
                    ContentUnavailableView(
                        "No Litters Yet",
                        systemImage: "pawprint.fill",
                        description: Text("Tap + to add your first litter.")
                    )
                } else {
                    List(litters) { litter in
                        NavigationLink(destination: LitterDetailView(litter: litter)) {
                            LitterRowView(litter: litter)
                        }
                    }
                }
            }
            .navigationTitle("Små Tassar")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddLitter = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddLitter) {
                AddLitterView()
            }
        }
        .tint(Color(hex: "#8B6914"))
    }
}

struct LitterRowView: View {
    let litter: Litter

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(litter.name)
                    .font(.headline)
                Text("\(litter.puppies.count) \(litter.puppies.count == 1 ? "puppy" : "puppies")")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if litter.isComplete {
                Label("Complete", systemImage: "checkmark.seal.fill")
                    .font(.caption)
                    .foregroundStyle(.green)
                    .labelStyle(.iconOnly)
            }
        }
        .padding(.vertical, 4)
    }
}
