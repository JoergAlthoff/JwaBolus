//
//  TimePeriod.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 23.02.25.
//
import Foundation

// Enum representing different time periods of the day
enum TimePeriod: String, CaseIterable, Codable {
    case morning = "Morning"
    case noon = "Noon"
    case evening = "Evening"
    case night = "Night"

    var localizedValue: String {
        switch self {
        case .morning: return NSLocalizedString("timePeriod.morning", comment: "")
        case .noon: return NSLocalizedString("timePeriod.noon", comment: "")
        case .evening: return NSLocalizedString("timePeriod.evening", comment: "")
        case .night: return NSLocalizedString("timePeriod.night", comment: "")
        }
    }
}

// Struct holding configuration values for each time period
struct TimePeriodConfig: Codable {
    var targetBg: String
    var correctionFactor: String
    var mealInsulinFactor: String

    // Computed Properties, die Strings automatisch in Double umwandeln
    var targetBgDouble: Double {
        return Double(targetBg) ?? 110.0
    }

    var correctionFactorDouble: Double {
        return Double(correctionFactor) ?? 20.0
    }

    var mealInsulinFactorDouble: Double {
        return Double(mealInsulinFactor) ?? 1.0
    }
}

// Default values for each time period
let defaultValues: [TimePeriod: TimePeriodConfig] = [
    .morning: TimePeriodConfig(targetBg: "110", correctionFactor: "20", mealInsulinFactor: "1.0"),
    .noon: TimePeriodConfig(targetBg: "110", correctionFactor: "20", mealInsulinFactor: "1.0"),
    .evening: TimePeriodConfig(targetBg: "110", correctionFactor: "20", mealInsulinFactor: "1.0"),
    .night: TimePeriodConfig(targetBg: "130", correctionFactor: "20", mealInsulinFactor: "1.0")
]
