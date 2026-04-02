import SwiftUI

struct SettingsView: View {
    @Environment(LanguageManager.self) private var lang

    var body: some View {
        @Bindable var lang = lang
        NavigationStack {
            Form {
                Section(lang.t("language")) {
                    Picker(lang.t("language"), selection: $lang.language) {
                        Text("English").tag("en")
                        Text("Svenska").tag("sv")
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle(lang.t("settings"))
        }
    }
}
