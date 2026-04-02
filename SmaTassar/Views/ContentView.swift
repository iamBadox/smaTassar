import SwiftUI

struct ContentView: View {
    @Environment(LanguageManager.self) private var lang

    var body: some View {
        TabView {
            LittersListView()
                .tabItem {
                    Label(lang.t("tab_litters"), systemImage: "pawprint.fill")
                }
            SettingsView()
                .tabItem {
                    Label(lang.t("tab_settings"), systemImage: "gearshape.fill")
                }
        }
        .tint(Color(hex: "#8B6914"))
    }
}
