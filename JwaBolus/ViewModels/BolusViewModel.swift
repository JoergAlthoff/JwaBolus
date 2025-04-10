import SwiftUI

class BolusViewModel: ObservableObject {
    // MARK: - UI-Related Values

    private let timePeriodConfigsKey = "timePeriodConfigs"
    private let lastInsulinDoseKey = "lastInsulinDose"
    private let lastInsulinTimestampKey = "lastInsulinTimestamp"

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
    @Published var remainingInsulin: Double = 0.0
    @Published var lastInsulinDose: Double = 0.0
    @Published var lastInsulinTimestamp: Date = .init()
    @Published var timePeriodConfigs: [TimePeriod: TimePeriodConfig] = defaultValues
    @Published var currentBGConverted: Double = 0
    @Published var carbohydratesConverted: Double = 0

    @AppStorage("insulinDuration") var insulinDuration: Double = 4.0
    @AppStorage("bgunit") var bgunitRaw: String = BloodGlucoseUnit.mgdL.rawValue
    @AppStorage("carbUnit") var carbUnitRaw: String = CarbUnit.grams.rawValue
    @AppStorage("sportintensity") var sportintensityRaw: String = SportIntensity.none.rawValue

    var bgunit: BloodGlucoseUnit {
        get { BloodGlucoseUnit(rawValue: bgunitRaw) ?? .mgdL }
        set {
            bgunitRaw = newValue.rawValue
            currentBGConverted = newValue.toMGDL(value: currentBG)
        }
    }

    var carbUnit: CarbUnit {
        get { CarbUnit(rawValue: carbUnitRaw) ?? .grams }
        set {
            carbUnitRaw = newValue.rawValue
            carbohydratesConverted = newValue.toGrams(value: carbohydrates)
        }
    }

    var sportintensity: SportIntensity {
        get { SportIntensity(rawValue: sportintensityRaw) ?? .none }
        set { sportintensityRaw = newValue.rawValue }
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
            var updated = timePeriodConfigs
            updated[period]?.correctionFactor = String(format: "%.1f", internalVal)
            timePeriodConfigs = updated
            Log.debug("✏️ Updating correction factor for \(period): \(internalVal)", category: .logic)
        }
        saveTimePeriodConfigs()
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
            var updated = timePeriodConfigs
            updated[period]?.mealInsulinFactor = String(format: "%.1f", internalVal)
            timePeriodConfigs = updated
            Log.debug("✏️ Updating meal factor for \(period): \(internalVal)", category: .logic)
        }
        saveTimePeriodConfigs()
    }

    // MARK: - Insulin Dose Management

    func setInsulinDose(amount: Double) {
        lastInsulinDose = amount
        lastInsulinTimestamp = Date()
        UserDefaults.standard.set(lastInsulinDose, forKey: lastInsulinDoseKey)
        UserDefaults.standard.set(lastInsulinTimestamp, forKey: lastInsulinTimestampKey)
        Log.debug("💾 Saved insulin dose and timestamp to UserDefaults", category: .storage)
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
        // We use manual UserDefaults writes here instead of @AppStorage to ensure both values
        // (dose and timestamp) are written atomically and remain logically consistent.
        // Using @AppStorage would trigger separate immediate writes and potential view updates
        // between these two assignments, which could lead to mismatched state (e.g. new dose with old timestamp)
        // and incorrect remainingInsulin calculations.
        UserDefaults.standard.set(lastInsulinDose, forKey: lastInsulinDoseKey)
        UserDefaults.standard.set(lastInsulinTimestamp, forKey: lastInsulinTimestampKey)
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

        Log.debug("Results: \n\t\(results)", category: .logic)
        resultsPerTimePeriod = results
        saveTimePeriodConfigs()
    }

    private func saveTimePeriodConfigs() {
        do {
            Log.debug("🧷 Attempting to save timePeriodConfigs with values: \(timePeriodConfigs)", category: .storage)
            let data = try JSONEncoder().encode(timePeriodConfigs)
            UserDefaults.standard.set(data, forKey: timePeriodConfigsKey)
            Log.debug("💾 Saved timePeriodConfigs to UserDefaults", category: .storage)
        } catch {
            Log.error("❌ Failed to encode timePeriodConfigs: \(error)", category: .storage)
        }
    }

    func loadTimePeriodConfigs() {
        if let data = UserDefaults.standard.data(forKey: timePeriodConfigsKey) {
            do {
                let decoded = try JSONDecoder().decode([TimePeriod: TimePeriodConfig].self, from: data)
                timePeriodConfigs = decoded
                Log.debug("📤 Decoded configs: \(decoded)", category: .storage)
                Log.debug("📦 Loaded timePeriodConfigs from UserDefaults", category: .storage)
            } catch {
                Log.error("❌ Failed to decode timePeriodConfigs: \(error)", category: .storage)
            }
        } else {
            Log.info("ℹ️ No stored timePeriodConfigs found, using defaults", category: .storage)
        }
    }

    func loadLastInsulinData() {
        lastInsulinDose = UserDefaults.standard.double(forKey: lastInsulinDoseKey)
        if let timestamp = UserDefaults.standard.object(forKey: lastInsulinTimestampKey) as? Date {
            lastInsulinTimestamp = timestamp
            Log.debug("📦 Loaded insulin dose: \(lastInsulinDose), timestamp: \(timestamp)", category: .storage)
        } else {
            Log.info("ℹ️ No stored insulin data found", category: .storage)
        }
        updateRemainingInsulin()
        objectWillChange.send() // 👈 Refresh View immediatly
        Log.info("""
            remainingInsulin = \(remainingInsulin), \
            dose = \(lastInsulinDose), \
            time = \(lastInsulinTimestamp), \
            duration = \(insulinDuration), \
            now = \(Date())
            """, category: .logic)
    }
}
