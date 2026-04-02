import SwiftUI

@Observable
class LanguageManager {
    var language: String {
        didSet {
            UserDefaults.standard.set(language, forKey: "appLanguage")
        }
    }

    init() {
        self.language = UserDefaults.standard.string(forKey: "appLanguage") ?? "en"
    }

    func t(_ key: String) -> String {
        Strings.translations[language]?[key] ?? Strings.translations["en"]?[key] ?? key
    }
}
