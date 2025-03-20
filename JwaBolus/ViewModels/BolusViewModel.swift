import SwiftUI

class BolusViewModel: ObservableObject {
    // MARK: - UI-Related Values
    @Published var currentBG: Double = 0
    @Published var carbohydrates: Double = 0
    @Published var totalInsulinUnits: Double?
    @Published var resultsPerTimePeriod: [TimePeriod: Double] = [:]
    @Published var sportIntensity: SportIntensity = .none
    @Published var remainingInsulin: Double = 0.0

    // MARK: - Dependency Injection
    var settingsStorage: SettingsStorage

    // MARK: - Constants
    private let SECONDS_PER_HOUR = 3600
    private let MINUTES_PER_HOUR = 60

    init(settingsStorage: SettingsStorage) {
        self.settingsStorage = settingsStorage
    }


    // MARK: - Unit Conversion Properties
    var currentBGConverted: Double {
        settingsStorage.bloodGlucoseUnit.toMGDL(value: currentBG)
    }

    var carbohydratesConverted: Double {
        settingsStorage.carbUnit.toGrams(value: carbohydrates)
    }

    // MARK: - Insulin Dose Management
    func setInsulinDose(amount: Double) {
        settingsStorage.lastInsulinDose = amount
        settingsStorage.lastInsulinTimestamp = Date()
    }

    func updateRemainingInsulin() {
        remainingInsulin = RemainingInsulinManager.calculateRemainingInsulin(
            lastDose: settingsStorage.lastInsulinDose,
            lastTimestamp: settingsStorage.lastInsulinTimestamp,
            durationHours: settingsStorage.insulinDuration
        )
    }

    func resetRemainingInsulin() {
        settingsStorage.lastInsulinDose = 0.0
        settingsStorage.lastInsulinTimestamp = Date()
    }

    func timeSinceLastDose() -> String {
        let now = Date()
        let interval = now.timeIntervalSince(settingsStorage.lastInsulinTimestamp)

        let hours = Int(interval) / SECONDS_PER_HOUR
        let minutes = (Int(interval) % SECONDS_PER_HOUR) / MINUTES_PER_HOUR

        return String(format: "%02d:%02d", hours, minutes)
    }


    // MARK: - Main Calculation: Insulin Dose
    func calculateInsulinDose() {
        print("calculateInsulinDose wurde aufgerufen")
        var results: [TimePeriod: Double] = [:]

        for period in TimePeriod.allCases {
            guard let config = settingsStorage.timePeriodConfigs[period] else {
                print("Kein Config für \(period)")
                continue
            }

            let targetBGValue = config.targetBZDouble
            let correctionFactorValue = config.correctionFactorDouble
            let mealInsulinFactor = config.mealInsulinFactorDouble
            let currentCarbs = carbohydratesConverted
            let currentBGValue = currentBGConverted

            let carbFactor = currentCarbs / 10.0 * mealInsulinFactor
            let bolusIU = currentCarbs > 0 ? carbFactor * sportIntensity.sportFaktor : 0.0
            let correctionIU = ((currentBGValue - targetBGValue) / correctionFactorValue) * sportIntensity.sportFaktor
            let totalIU = bolusIU + correctionIU

            results[period] = totalIU

            print("Period: \(period), Carbs: \(currentCarbs), BG: \(currentBGValue), Bolus: \(bolusIU), Korrektur: \(correctionIU), Total: \(totalIU)")
        }

        print("Ergebnisse:", results)
        resultsPerTimePeriod = results
    }
}
