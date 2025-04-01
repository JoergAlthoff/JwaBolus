import SwiftUI

class BolusViewModel: ObservableObject {
    // MARK: - UI-Related Values

    @Published var currentBG: Double = 0 {
        didSet {
            currentBGConverted = bgunit.toMGDL(value: currentBG)
        }
    }

    @Published var carbohydrates: Double = 0 {
        didSet {
            carbohydratesConverted = carbUnit.toGrams(value: carbohydrates)
        }
    }

    @Published var totalInsulinUnits: Double?
    @Published var resultsPerTimePeriod: [TimePeriod: Double] = [:]
    @Published var sportintensity: SportIntensity = .none
    @Published var remainingInsulin: Double = 0.0
    @Published var insulinDuration: Double = 4.0
    @Published var lastInsulinDose: Double = 0.0
    @Published var lastInsulinTimestamp: Date = .init()
    @Published var timePeriodConfigs: [TimePeriod: TimePeriodConfig] = defaultValues

    @Published var currentBGConverted: Double = 0
    @Published var carbohydratesConverted: Double = 0

    @Published var bgunit: BloodGlucoseUnit = .mgdL {
        didSet {
            currentBGConverted = bgunit.toMGDL(value: currentBG)
        }
    }

    @Published var carbUnit: CarbUnit = .grams {
        didSet {
            carbohydratesConverted = carbUnit.toGrams(value: carbohydrates)
        }
    }

    // MARK: - Constants

    private static let defaultTargetBG = "120"
    private static let defaultCorrectionFactor = "20"
    private static let defaultMealFactor = "1.0"

    // MARK: - Anzeige-Only Konvertierung für SettingsView

    func displayTargetBG(for period: TimePeriod) -> String {
        guard let raw = Double(timePeriodConfigs[period]?.targetBg ?? "120") else {
            return "120.0"
        }
        let displayValue = UnitConverter.toDisplayBG(raw, as: bgunit)
        return String(format: "%.1f", displayValue)
    }

    func updateTargetBG(for period: TimePeriod, from displayValue: String) {
        if let val = Double(displayValue.replacingOccurrences(of: ",", with: ".")) {
            let internalVal = UnitConverter.fromDisplayBG(val, from: bgunit)
            timePeriodConfigs[period]?.targetBg = String(format: "%.1f", internalVal)
        }
    }

    func displayCorrectionFactor(for period: TimePeriod) -> String {
        guard let raw = Double(timePeriodConfigs[period]?.correctionFactor ?? "20") else {
            return "20.0"
        }
        let displayValue = UnitConverter.toDisplayBG(raw, as: bgunit)
        return String(format: "%.1f", displayValue)
    }

    func updateCorrectionFactor(for period: TimePeriod, from displayValue: String) {
        if let val = Double(displayValue.replacingOccurrences(of: ",", with: ".")) {
            let internalVal = UnitConverter.fromDisplayBG(val, from: bgunit)
            timePeriodConfigs[period]?.correctionFactor = String(format: "%.1f", internalVal)
        }
    }

    func displayMealFactor(for period: TimePeriod) -> String {
        guard let raw = Double(timePeriodConfigs[period]?.mealInsulinFactor ?? "1.0") else {
            return "1.0"
        }
        return String(format: "%.1f", raw)
    }

    func updateMealFactor(for period: TimePeriod, from displayValue: String) {
        if let val = Double(displayValue.replacingOccurrences(of: ",", with: ".")) {
            let internalVal = val
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
        let duration = Measurement(value: interval, unit: UnitDuration.seconds)
        let totalMinutes = Int(duration.converted(to: .minutes).value)
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        return String(format: "%02d:%02d", hours, minutes)
    }

    // MARK: - Main Calculation: Insulin Dose

    func calculateInsulinDose() {
        Log.debug("calculateInsulinDose called", category: .logic)

        var results: [TimePeriod: Double] = [:]

        for period in TimePeriod.allCases {
            guard let config = timePeriodConfigs[period] else {
                Log.error("No config für \(period)", category: .storage)
                continue
            }

            let targetBgValue = Double(config.targetBg) ?? 110.0
            let correctionFactorValue = Double(config.correctionFactor) ?? 20.0
            let mealInsulinFactor = Double(config.mealInsulinFactor) ?? 1.0
            let currentCarbs = carbohydratesConverted
            let currentBGValue = currentBGConverted

            let carbFactor = currentCarbs / 10.0 * mealInsulinFactor
            let bolusIU = currentCarbs > 0 ? carbFactor * sportintensity.sportFaktor : 0.0
            let correctionIU = ((currentBGValue - targetBgValue) / correctionFactorValue) * sportintensity.sportFaktor
            let totalIU = bolusIU + correctionIU

            results[period] = totalIU

            Log.debug("""
            Period: \(period), \
            Carbs: \(currentCarbs), \
            BG: \(currentBGValue), \
            Sport: \(sportintensity.sportFaktor), \
            Bolus: \(bolusIU), \
            CorrectionFaktor: \(correctionIU), \
            Total: \(totalIU)
            """, category: .logic)
        }

        Log.debug("Results: \n\t\(results)", category: .logic )
        resultsPerTimePeriod = results
    }
}
