import SwiftUI
import SwiftData

struct LitterDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(LanguageManager.self) private var lang
    @Bindable var litter: Litter
    @State private var showingAddPuppy = false
    @State private var showingCharts = false
    @State private var puppyToEdit: Puppy?

    var body: some View {
        Group {
            if litter.puppies.isEmpty {
                ContentUnavailableView(
                    lang.t("no_puppies_title"),
                    systemImage: "pawprint",
                    description: Text(lang.t("no_puppies_desc"))
                )
            } else {
                List(litter.puppies) { puppy in
                    NavigationLink(destination: PuppyDetailView(puppy: puppy)) {
                        PuppyRowView(puppy: puppy)
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            modelContext.delete(puppy)
                        } label: {
                            Label(lang.t("delete"), systemImage: "trash")
                        }
                    }
                    .swipeActions(edge: .leading) {
                        Button {
                            puppyToEdit = puppy
                        } label: {
                            Label(lang.t("edit"), systemImage: "pencil")
                        }
                        .tint(.orange)
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
                        Label(lang.t("add_puppy"), systemImage: "plus")
                    }
                    Button {
                        withAnimation {
                            litter.isComplete.toggle()
                        }
                    } label: {
                        Label(
                            litter.isComplete ? lang.t("reopen_litter") : lang.t("mark_complete"),
                            systemImage: litter.isComplete ? "arrow.uturn.backward" : "checkmark.seal"
                        )
                    }
                    Button {
                        showingCharts = true
                    } label: {
                        Label(lang.t("view_charts"), systemImage: "chart.line.uptrend.xyaxis")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(isPresented: $showingAddPuppy) {
            AddPuppyView(litter: litter)
        }
        .sheet(item: $puppyToEdit) { puppy in
            EditPuppyView(puppy: puppy)
        }
        .sheet(isPresented: $showingCharts) {
            LitterChartsView(litter: litter)
        }
        .safeAreaInset(edge: .bottom) {
            if !litter.puppies.isEmpty {
                Button {
                    showingCharts = true
                } label: {
                    Label(lang.t("view_litter_charts"), systemImage: "chart.line.uptrend.xyaxis")
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
    @Environment(LanguageManager.self) private var lang
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
                    Text(puppy.sex == "Male" ? "♂" : "♀")
                        .foregroundStyle(puppy.sex == "Male" ? Color(red: 0.5, green: 0.75, blue: 1.0) : Color(red: 1.0, green: 0.6, blue: 0.75))
                        .fontWeight(.bold)
                    Text(puppy.sex == "Male" ? lang.t("male") : lang.t("female"))
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                Text("\(lang.t("born")) \(dateFormatter.string(from: puppy.birthDate))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("\(lang.t("birth_weight_label")) \(Int(puppy.birthWeight))g")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
