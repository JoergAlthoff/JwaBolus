import SwiftUI

class BolusViewModel: ObservableObject {

    var settingsStorage: SettingsStorage 

    init(settingsStorage: SettingsStorage) {
        self.settingsStorage = settingsStorage
    }

    // MARK: - UI-Related Values
    @Published var currentBG: Double = 0
    @Published var carbohydrates: Double = 0
    @Published var totalInsulinUnits: Double?
    @Published var resultsPerTimePeriod: [TimePeriod: Double] = [:]
    @Published var sportIntensity: SportIntensity = .none

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

    var remainingInsulin: Double {
        RemainingInsulinManager.calculateRemainingInsulin(
            lastDose: settingsStorage.lastInsulinDose,
            lastTimestamp: settingsStorage.lastInsulinTimestamp,
            durationHours: settingsStorage.insulinDuration
        )
    }

    func resetRemainingInsulin() {
        settingsStorage.lastInsulinDose = 0.0
        settingsStorage.lastInsulinTimestamp = Date()
    }

    // MARK: - Main Calculation: Insulin Dose
    func calculateInsulinDose() {
        // Close keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        var results: [TimePeriod: Double] = [:]

        for period in TimePeriod.allCases {
            guard let config = settingsStorage.timePeriodConfigs?[period] else { continue }
            let targetBGValue = config.targetBZ
            let correctionFactorValue = config.correctionFactor
            let mealInsulinFactor = config.mealInsulinFactor
            let currentCarbs = carbohydratesConverted
            let currentBGValue = currentBGConverted

            let carbFactor = currentCarbs / 10.0 * mealInsulinFactor
            let bolusIU = currentCarbs > 0 ? carbFactor * sportIntensity.sportFaktor : 0.0
            let correctionIU = ((currentBGValue - targetBGValue) / correctionFactorValue) * sportIntensity.sportFaktor
            results[period] = bolusIU + correctionIU
        }

        resultsPerTimePeriod = results
    }
}
