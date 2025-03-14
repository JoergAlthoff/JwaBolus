import SwiftUI

class BolusViewModel: ObservableObject {
    // Dynamic values observed in the UI (not persistent)
    @Published var currentBG: Int = 0
    @Published var carbohydrates: Int = 0
    @Published var totalInsulinUnits: Double?
    @Published var resultsPerTimePeriod: [TimePeriod: Double] = [:]
    @Published var sportIntensity: SportIntensity = .no

    // Private backing properties with AppStorage for persistent values
    @AppStorage("lastInsulinDose") private var storedLastInsulinDose: Double = 0.0
    @AppStorage("lastInsulinTimestamp") private var storedLastInsulinTimestampString: String = ""
    @AppStorage("insulinDuration") private var storedInsulinDuration: Double = 4.0
    @AppStorage("timePeriodConfigs") private var storedTimePeriodConfigsData: Data = {
        // Initialization
        let encoder = JSONEncoder()
        return (try? encoder.encode(defaultValues)) ?? Data()
    }()

    // Computed properties for persistent values (Getter and Setter)
    var timePeriodConfigs: [TimePeriod: TimePeriodConfig] {
        get {
            return (try? JSONDecoder().decode([TimePeriod: TimePeriodConfig].self, from: storedTimePeriodConfigsData))
            ?? defaultValues
        }
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                storedTimePeriodConfigsData = encoded
            }
        }
    }

    var lastInsulinDose: Double {
        get { storedLastInsulinDose }
        set { storedLastInsulinDose = newValue }
    }

    var lastInsulinTimestamp: Date {
        get {
            if let date = try? Date(storedLastInsulinTimestampString, strategy: .iso8601) {
                return date
            } else {
                let now = Date()
                storedLastInsulinTimestampString = now.formatted(.iso8601)
                return now
            }
        }
        set {
            storedLastInsulinTimestampString = newValue.formatted(.iso8601)
        }
    }

    var insulinDuration: Double {
        get { storedInsulinDuration }
        set { storedInsulinDuration = newValue }
    }

    // MARK: - Business Logic

    // Stores the insulin dose and updates the timestamp.
    func setInsulinDose(menge: Double) {
        self.lastInsulinDose = menge
        self.lastInsulinTimestamp = Date()
    }

    // Calculates the remaining insulin
    var remainingInsulin: Double {
        let totalDurationMinutes = insulinDuration * 60
        let elapsedMinutes = minutesSinceLastInsulinDose()
        if elapsedMinutes >= totalDurationMinutes {
            return 0.0
        }
        // Linear decay: Initial amount * (1 - (elapsed minutes / total duration))
        return lastInsulinDose * (1 - (elapsedMinutes / totalDurationMinutes))
    }

    // Resets the remaining insulin value: lastInsulinDose is set to 0,
    // and the last insulin time is updated to the current time.
    func resetRemainingInsulin() {
        self.lastInsulinDose = 0.0
        self.lastInsulinTimestamp = Date()
    }

    // Calculates the elapsed time since the last insulin dose in minutes.
    func minutesSinceLastInsulinDose() -> Double {
        let difference = Date().timeIntervalSince(lastInsulinTimestamp)
        return difference / 60.0
    }

    // Calculates the remaining insulin value based on elapsed time and insulin duration.
    // Computes the insulin dose (IU) based on current values.
    func calculateInsulinDose() {
        // Close the keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)

        var results: [TimePeriod: Double] = [:]

        for period in TimePeriod.allCases {
            guard let config = timePeriodConfigs[period] else { continue }
            let targetBGValue = config.targetBZ
            let correctionFactorValue = config.correctionFactor
            let mealInsulinFactor = config.mealInsulinFactor
            let currentCarbs = Double(max(carbohydrates, 0))
            let currentBGValue = Double(max(currentBG, 0))

            let carbFactor = currentCarbs / 10.0 * mealInsulinFactor
            let bolusIU = currentCarbs > 0
                ? carbFactor * sportIntensity.sportFaktor
                : 0.0
            let correctionIU = ((currentBGValue - targetBGValue) / correctionFactorValue) * sportIntensity.sportFaktor
            results[period] = bolusIU + correctionIU
            print("Sport Intensity: \(sportIntensity), Factor: \(sportIntensity.sportFaktor)")
            print("Current Carbs: \(currentCarbs), Current BG: \(currentBGValue)")
            print("Target BG: \(targetBGValue), Correction Factor: \(correctionFactorValue)")
        }

        resultsPerTimePeriod = results
        print("Final Results: \(resultsPerTimePeriod)")
    }
}
