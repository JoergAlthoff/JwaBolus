import SwiftUI

class SettingsStorage: ObservableObject {

    // MARK: - Persistenz für alle Variablen mit UserDefaults
    @Published var bloodGlucoseUnit: BloodGlucoseUnit {
        didSet { UserDefaults.standard.set(bloodGlucoseUnit.rawValue, forKey: "bloodGlucoseUnit") }
    }

    @Published var carbUnit: CarbUnit {
        didSet { UserDefaults.standard.set(carbUnit.rawValue, forKey: "carbUnit") }
    }

    @Published var insulinDuration: Double {
        didSet { UserDefaults.standard.set(insulinDuration, forKey: "insulinDuration") }
    }

    @Published var lastInsulinDose: Double {
        didSet { UserDefaults.standard.set(lastInsulinDose, forKey: "lastInsulinDose") }
    }

    @Published var lastInsulinTimestamp: Date {
        didSet {
            let timestampString = ISO8601DateFormatter().string(from: lastInsulinTimestamp) // ✅ In UTC speichern
            UserDefaults.standard.set(timestampString, forKey: "lastInsulinTimestamp")
        }
    }

    @Published var timePeriodConfigs: [TimePeriod: TimePeriodConfig] {
        didSet {
            if let encoded = try? JSONEncoder().encode(timePeriodConfigs) {
                UserDefaults.standard.set(encoded, forKey: "timePeriodConfigs")
                print("Gespeichert: \(timePeriodConfigs)")
            }
        }
    }

    // MARK: - Initialisierung der Variablen aus UserDefaults
    init() {
        // Werte aus den User.Defaulkts holen
        let storedBloodGlucoseUnit = UserDefaults.standard.string(forKey: "bloodGlucoseUnit") ?? BloodGlucoseUnit.mgdL.rawValue
        let storedCarbUnit = UserDefaults.standard.string(forKey: "carbUnit") ?? CarbUnit.grams.rawValue
        let storedInsulinDuration = UserDefaults.standard.double(forKey: "insulinDuration")
        let storedLastInsulinDose = UserDefaults.standard.double(forKey: "lastInsulinDose")
        let storedLastInsulinTimestamp = UserDefaults.standard.string(forKey: "lastInsulinTimestamp") ?? ""
        let storedTimePeriodConfigsData = UserDefaults.standard.data(forKey: "timePeriodConfigs")

        // Gekadene Werte auswerten und ggfs. ordentlich initialisieren
        let parsedBloodGlucoseUnit = BloodGlucoseUnit(rawValue: storedBloodGlucoseUnit) ?? .mgdL
        let parsedCarbUnit = CarbUnit(rawValue: storedCarbUnit) ?? .grams
        let parsedInsulinDuration = storedInsulinDuration == 0 ? 4.0 : storedInsulinDuration
        let parsedLastInsulinDose = storedLastInsulinDose

        let parsedLastInsulinTimestamp: Date
        if let decodedDate = ISO8601DateFormatter().date(from: storedLastInsulinTimestamp) {
            parsedLastInsulinTimestamp = decodedDate
        } else {
            parsedLastInsulinTimestamp = Date()
        }

        let parsedTimePeriodConfigs: [TimePeriod: TimePeriodConfig] = {
            if let savedData = storedTimePeriodConfigsData,
               let decodedConfigs = try? JSONDecoder().decode([TimePeriod: TimePeriodConfig].self, from: savedData),
               !decodedConfigs.isEmpty {
                return decodedConfigs
            } else {
                print("Standardwerte für timePeriodConfigs gesetzt.")
                return defaultValues
            }
        }()

        // Jetzt erst die gespeicherten Properties initialisieren
        self.bloodGlucoseUnit = parsedBloodGlucoseUnit
        self.carbUnit = parsedCarbUnit
        self.insulinDuration = parsedInsulinDuration
        self.lastInsulinDose = parsedLastInsulinDose
        self.lastInsulinTimestamp = parsedLastInsulinTimestamp
        self.timePeriodConfigs = parsedTimePeriodConfigs
    }

    // MARK: - Alle Variablen speichern
    func saveSettings() {
        UserDefaults.standard.set(bloodGlucoseUnit.rawValue, forKey: "bloodGlucoseUnit")
        UserDefaults.standard.set(carbUnit.rawValue, forKey: "carbUnit")
        UserDefaults.standard.set(insulinDuration, forKey: "insulinDuration")
        UserDefaults.standard.set(lastInsulinDose, forKey: "lastInsulinDose")

        let timestampString = ISO8601DateFormatter().string(from: lastInsulinTimestamp)
        UserDefaults.standard.set(timestampString, forKey: "lastInsulinTimestamp")

        if let encoded = try? JSONEncoder().encode(timePeriodConfigs) {
            UserDefaults.standard.set(encoded, forKey: "timePeriodConfigs")
        }

        print("Alle Einstellungen gespeichert.")
    }

    // MARK: - Reset-Funktion für Standardwerte
    func resetToDefaults() {
        bloodGlucoseUnit = .mgdL
        carbUnit = .grams
        insulinDuration = 4.0
        lastInsulinDose = 0.0
        lastInsulinTimestamp = Date()
        timePeriodConfigs = defaultValues
    }
}
