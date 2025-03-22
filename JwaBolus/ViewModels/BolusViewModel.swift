import SwiftUI

class BolusViewModel: ObservableObject {
    // MARK: - UI-Related Values
    @Published var currentBG: Double = 0
    @Published var carbohydrates: Double = 0
    @Published var totalInsulinUnits: Double?
    @Published var resultsPerTimePeriod: [TimePeriod: Double] = [:]
    @Published var sportIntensity: SportIntensity = .none
    @Published var remainingInsulin: Double = 0.0
    @Published var insulinDuration: Double = 4.0
    @Published var lastInsulinDose: Double = 0.0
    @Published var lastInsulinTimestamp: Date = Date()
    @Published var timePeriodConfigs: [TimePeriod: TimePeriodConfig] = defaultValues

    @Published var currentBGConverted: Double = 0
    @Published var carbohydratesConverted: Double = 0

    @Published var bloodGlucoseUnit: BloodGlucoseUnit = .mgdL {
        didSet {
            currentBGConverted = bloodGlucoseUnit.toMGDL(value: currentBG)
        }
    }

    @Published var carbUnit: CarbUnit = .grams {
        didSet {
            carbohydratesConverted = carbUnit.toGrams(value: carbohydrates)
        }
    }

    // MARK: - Constants
    private let SECONDS_PER_HOUR = 3600
    private let MINUTES_PER_HOUR = 60

    // MARK: - Anzeige-Only Konvertierung für SettingsView
    func displayTargetBZ(for period: TimePeriod) -> String {
        guard let raw = Double(timePeriodConfigs[period]?.targetBZ ?? "") else { return "" }
        let displayValue = UnitConverter.toDisplayBZ(raw, as: bloodGlucoseUnit)
        return String(format: "%.1f", displayValue)
    }

    func updateTargetBZ(for period: TimePeriod, from displayValue: String) {
        if let val = Double(displayValue.replacingOccurrences(of: ",", with: ".")) {
            let internalVal = UnitConverter.fromDisplayBZ(val, from: bloodGlucoseUnit)
            timePeriodConfigs[period]?.targetBZ = String(format: "%.1f", internalVal)
        }
    }

    func displayCorrectionFactor(for period: TimePeriod) -> String {
        guard let raw = Double(timePeriodConfigs[period]?.correctionFactor ?? "") else { return "" }
        let displayValue = UnitConverter.toDisplayBZ(raw, as: bloodGlucoseUnit)
        return String(format: "%.1f", displayValue)
    }

    func updateCorrectionFactor(for period: TimePeriod, from displayValue: String) {
        if let val = Double(displayValue.replacingOccurrences(of: ",", with: ".")) {
            let internalVal = UnitConverter.fromDisplayBZ(val, from: bloodGlucoseUnit)
            timePeriodConfigs[period]?.correctionFactor = String(format: "%.1f", internalVal)
        }
    }

    func displayMealFactor(for period: TimePeriod) -> String {
        guard let raw = Double(timePeriodConfigs[period]?.mealInsulinFactor ?? "") else { return "" }
        let displayValue = UnitConverter.toDisplayCarbs(raw, as: carbUnit)
        return String(format: "%.1f", displayValue)
    }

    func updateMealFactor(for period: TimePeriod, from displayValue: String) {
        if let val = Double(displayValue.replacingOccurrences(of: ",", with: ".")) {
            let internalVal = UnitConverter.fromDisplayCarbs(val, from: carbUnit)
            timePeriodConfigs[period]?.mealInsulinFactor = String(format: "%.1f", internalVal)
        }
    }

    // MARK: - Insulin Dose Management
    func setInsulinDose(amount: Double) {
        lastInsulinDose = amount
        lastInsulinTimestamp = Date()
    }

    func updateRemainingInsulin() {
        remainingInsulin = RemainingInsulinManager.calculateRemainingInsulin(
            lastDose: lastInsulinDose,
            lastTimestamp: lastInsulinTimestamp,
            durationHours: insulinDuration
        )
    }

    func resetRemainingInsulin() {
        lastInsulinDose = 0.0
        lastInsulinTimestamp = Date()
        updateRemainingInsulin()
    }

    func timeSinceLastDose() -> String {
        let now = Date()
        let interval = now.timeIntervalSince(lastInsulinTimestamp)

        let hours = Int(interval) / SECONDS_PER_HOUR
        let minutes = (Int(interval) % SECONDS_PER_HOUR) / MINUTES_PER_HOUR

        return String(format: "%02d:%02d", hours, minutes)
    }

    // MARK: - Main Calculation: Insulin Dose
    func calculateInsulinDose() {
        print("calculateInsulinDose wurde aufgerufen")
        var results: [TimePeriod: Double] = [:]

        for period in TimePeriod.allCases {
            guard let config = timePeriodConfigs[period] else {
                print("Kein Config für \(period)")
                continue
            }

            let targetBGValue = Double(config.targetBZ) ?? 110.0
            let correctionFactorValue = Double(config.correctionFactor) ?? 20.0
            let mealInsulinFactor = Double(config.mealInsulinFactor) ?? 1.0
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
