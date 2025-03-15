//
//  SettingsStorage.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 14.03.25.
//
import SwiftUI

class SettingsStorage: ObservableObject {

    // MARK: - Stored Properties
    @AppStorage("bloodGlucoseUnit") var bloodGlucoseUnit: BloodGlucoseUnit = .mgdL
    @AppStorage("carbUnit") var carbUnit: CarbUnit = .grams
    @AppStorage("insulinDuration") var insulinDuration: Double = 4.0
    @AppStorage("lastInsulinDose") var lastInsulinDose: Double = 0.0
    @AppStorage("lastInsulinTimestamp") private var storedLastInsulinTimestampString: String = ""
    @AppStorage("timePeriodConfigs") private var storedTimePeriodConfigsData: Data = Data()

    // MARK: - Published Properties for ViewModel Access
    @Published var lastInsulinTimestamp: Date = Date()
    @Published var timePeriodConfigs: [TimePeriod: TimePeriodConfig]?

    // MARK: - Initialization
    init() {
        DispatchQueue.main.async {
            self.loadStoredValues()
        }
    }

    // MARK: - Load Values
    private func loadStoredValues() {
        lastInsulinTimestamp = (try? Date(storedLastInsulinTimestampString, strategy: .iso8601)) ?? Date()

        if let decodedConfigs = try? JSONDecoder().decode([TimePeriod: TimePeriodConfig].self,
                                                          from: storedTimePeriodConfigsData), !decodedConfigs.isEmpty {
            timePeriodConfigs = decodedConfigs
        } else {
            timePeriodConfigs = defaultValues
        }
    }

    // MARK: - Save Values
    func save() {
        // Speichert den letzten Insulin-Zeitstempel sicher
        storedLastInsulinTimestampString = lastInsulinTimestamp.formatted(.iso8601)

        // Speichert die Zeitperioden-Konfiguration, wenn sie nicht nil ist
        if let configs = timePeriodConfigs, let encoded = try? JSONEncoder().encode(configs) {
            storedTimePeriodConfigsData = encoded
        }
    }

    // MARK: - Reset to Defaults
    func resetToDefaults() {
        bloodGlucoseUnit = .mgdL
        carbUnit = .grams
        insulinDuration = 4.0
        lastInsulinDose = 0.0
        lastInsulinTimestamp = Date()
        timePeriodConfigs = defaultValues
        save()
    }
}
