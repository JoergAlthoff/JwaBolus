//
//  TimePeriod.swift
//  JwaBolus
//
//  Created by Jörg Althoff on 23.02.25.
//
import Foundation

// Enum representing different time periods of the day
enum TimePeriod: String, CaseIterable, Codable {
    case morning = "Früh"
    case noon = "Mittag"
    case evening = "Abend"
    case night = "Nacht"
}

// Struct holding configuration values for each time period
struct TimePeriodConfig: Codable {
    var targetBZ: Double
    var correctionFactor: Double
    var mealInsulinFactor: Double
}

// Default values for each time period
let defaultValues: [TimePeriod: TimePeriodConfig] = [
    .morning: TimePeriodConfig(targetBZ: 110, correctionFactor: 20, mealInsulinFactor: 1.0),
    .noon: TimePeriodConfig(targetBZ: 110, correctionFactor: 20, mealInsulinFactor: 1.0),
    .evening: TimePeriodConfig(targetBZ: 110, correctionFactor: 20, mealInsulinFactor: 1.0),
    .night: TimePeriodConfig(targetBZ: 110, correctionFactor: 20, mealInsulinFactor: 1.0)
]
