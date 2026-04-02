import SwiftUI
import SwiftData

struct LittersListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(LanguageManager.self) private var lang
    @Query(sort: \Litter.dateCreated, order: .reverse) private var litters: [Litter]
    @State private var showingAddLitter = false
    @State private var litterToEdit: Litter?

    var body: some View {
        NavigationStack {
            Group {
                if litters.isEmpty {
                    ContentUnavailableView(
                        lang.t("no_litters_title"),
                        systemImage: "pawprint.fill",
                        description: Text(lang.t("no_litters_desc"))
                    )
                } else {
                    List(litters) { litter in
                        NavigationLink(destination: LitterDetailView(litter: litter)) {
                            LitterRowView(litter: litter)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                modelContext.delete(litter)
                            } label: {
                                Label(lang.t("delete"), systemImage: "trash")
                            }
                        }
                        .swipeActions(edge: .leading) {
                            Button {
                                litterToEdit = litter
                            } label: {
                                Label(lang.t("edit"), systemImage: "pencil")
                            }
                            .tint(.orange)
                        }
                    }
                }
            }
            .navigationTitle(lang.t("app_title"))
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
            .sheet(item: $litterToEdit) { litter in
                EditLitterView(litter: litter)
            }
        }
    }
}

struct LitterRowView: View {
    @Environment(LanguageManager.self) private var lang
    let litter: Litter

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(litter.name)
                    .font(.headline)
                Text("\(litter.puppies.count) \(litter.puppies.count == 1 ? lang.t("puppy_singular") : lang.t("puppy_plural"))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            if litter.isComplete {
                Label(lang.t("complete"), systemImage: "checkmark.seal.fill")
                    .font(.caption)
                    .foregroundStyle(.green)
                    .labelStyle(.iconOnly)
            }
        }
        .padding(.vertical, 4)
    }
}
